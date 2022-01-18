# SPI installer adapted from Tow-Boot: https://github.com/Tow-Boot/Tow-Boot
# Copyright (c) 2021 Samuel Dionne-Riel and respective contributors.

{ lib, buildPackages, runCommandNoCC, writeText, riscv64 }:

let
  uboot = riscv64.uboot-unmatched;
  spiImage = riscv64.uboot-unmatched-spi-image;

  spiBus = "1:0";

  mkScript = file: runCommandNoCC "out.scr" {
    nativeBuildInputs = with buildPackages; [
      ubootTools
    ];
  } ''
    mkimage -C none -A riscv -T script -d ${file} $out
  '';

  flashscript = let
    error = messages: ''
      echo ""
      echo " ********* "
      echo " * ERROR * "
      echo " ********* "
      echo ""
      ${messages}
      echo ""
      echo "* * * Rebooting in 60 seconds"
      echo ""
      reset
    '';
  in writeText "unmatched-flash-spi.cmd" ''
    echo ""
    echo ""
    echo "Firmware installer"
    echo ""
    echo ""

    echo "Installing U-Boot to the SPI flash in 10 seconds!"
    sleep 10

    # Some variables we will be using
    # (Useless use of setexpr, but eh)
    setexpr new_firmware_addr_r $kernel_addr_r + 0
    setexpr old_firmware_addr_r $ramdisk_addr_r + 0
    setexpr new_firmware_addr_r_tail $new_firmware_addr_r + 0x2000

    echo "devtype = $devtype"
    echo "devnum = $devnum"
    part list $devtype $devnum -bootable bootpart
    echo "bootpart = $bootpart"
    echo ""
    echo ":: Starting flash operation"
    echo ""

    echo "-> Initializing SPI Flash subsystem..."
    if sf probe ${spiBus}; then

      echo ""
      echo "-> Reading new firmware from storage..."
      if load $devtype $devnum:$bootpart $new_firmware_addr_r spi-image.img; then
        setexpr new_firmware_size $filesize + 0
        setexpr new_firmware_size_tail $filesize - 0x2000

        # Erasing the flash in advance doesn't provide any benefits,
        # because the boot device is selected with the MSEL DIP switch.
        # It's configured to boot from SD now so it's safe to just
        # flash directly.

        echo ""
        echo "-> Writing new firmware to SPI..."

        if sf update $new_firmware_addr_r 0x0 $new_firmware_size; then
          echo ""
          echo "✅ Flashing seems to have been successful!"
          echo "You can now set MSEL[3:0] = 0110"
          echo ""
          echo "Resetting in 5 seconds"
          sleep 5
          reset
        else
          ${error ''
          echo "❌ Error flashing new firmware to SPI Flash."
          echo "   Please reboot to try again."
          ''}
        fi

      # load spi-image.img
      else
        ${error ''
        echo "⚠️ Error reading new firmware from storage."
        echo "  Rebooting should be safe, nothing was done."
        ''}
      fi

    # sf probe
    else
      ${error ''
      echo "⚠️ Running `sf probe` failed unexpectedly."
      echo "  Rebooting should be safe, nothing was done."
      ''}
    fi
  '';

in runCommandNoCC "uboot-unmatched-spi-installer.img" {
  nativeBuildInputs = with buildPackages; [
    e2fsprogs e2tools gptfdisk util-linux
  ];
} ''
  # Installer Partition
  fallocate -l 10M installer.bin
  mkfs.ext4 installer.bin
  e2cp ${mkScript flashscript} installer.bin:boot.scr
  e2cp ${spiImage} installer.bin:spi-image.img

  # SD Image
  fallocate -l 20M image.bin

  sgdisk -g --clear --set-alignment=1 \
    --new=1:34:+1M: --change-name=1:spl --typecode=1:5b193300-fc78-40cd-8002-e86c45580b47 \
    --new=2:2082:+4M: --change-name=2:uboot --typecode=2:2e54b353-1271-4842-806f-e436d6af6985 \
    --new=3:10280:0 --change-name=3:installer --typecode=3:8300 -A 3:set:2 \
    image.bin

  dd if=${uboot}/u-boot-spl.bin of=image.bin bs=512 seek=34 conv=notrunc
  dd if=${uboot}/u-boot.itb of=image.bin bs=512 seek=2082 conv=notrunc
  dd if=installer.bin of=image.bin bs=512 seek=10280 conv=notrunc

  cp image.bin $out
''
