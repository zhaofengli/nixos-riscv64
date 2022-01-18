# SiFive's patches

{ fetchFromGitHub }: let
  metaSifive = fetchFromGitHub {
    owner = "sifive";
    repo = "meta-sifive";
    rev = "0eabb6030471da23789b4f0956e25767e966433d"; # 2021.12
    sha256 = "sha256-zv05wAQ+pVUQGq7GCrU8tLzqGf7PLUOswUoiQ0A6Dd4=";
  };
in {
  ubootPatches = map (patch: "${metaSifive}/recipes-bsp/u-boot/files/riscv64/${patch}") [
    "0001-riscv-sifive-unleashed-support-compressed-images.patch"
    "0002-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch"
    "0003-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch"
    "0004-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch"
    #"0005-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch" # TODO: need to rebase
    "0006-riscv-sifive-unmatched-leave-128MiB-for-ramdisk.patch"
    "0007-riscv-sifive-unmatched-disable-FDT-and-initrd-reloca.patch"
  ];
  kernelPatches = map (patch: "${metaSifive}/recipes-kernel/linux/files/${patch}") [
    "0001-riscv-sifive-fu740-cpu-1-2-3-4-set-compatible-to-sif.patch"
    "0002-riscv-sifive-unmatched-update-regulators-values.patch"
    "0003-riscv-sifive-unmatched-define-PWM-LEDs.patch"
    #"0004-riscv-sifive-unmatched-add-gpio-poweroff-node.patch"
    "0005-SiFive-HiFive-Unleashed-Add-PWM-LEDs-D1-D2-D3-D4.patch"
    "0006-riscv-sifive-unleashed-define-opp-table-cpufreq.patch"
    #"0007-riscv-enable-generic-PCI-resource-mapping.patch"
    #"29868ae1478fe18231672da94c4e862a03218a25.patch"
    "riscv-sbi-srst-support.patch"
  ];
}
