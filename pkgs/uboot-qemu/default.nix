{ lib, buildUBoot, fetchpatch }: buildUBoot {
  defconfig = "qemu-riscv64_smode_defconfig";

  extraMeta.platforms = [ "riscv64-linux" ];
  extraPatches = [
    (fetchpatch {
      url = "https://salsa.debian.org/debian/u-boot/-/raw/sid/debian/patches/riscv64/qemu-riscv64_smode-sifive-fu540-fix-extlinux-define-.patch";
      sha256 = "0vf9v8zd6k1hlglfk29mzcsz9dxsfp112llhwx627wzbsy6hrcgm";
    })
  ];

  filesToInstall = [ "u-boot" "u-boot.bin" "u-boot-nodtb.bin" ];
}
