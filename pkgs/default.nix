final: prev: rec {
  riscv64 = rec {
    meta-sifive = final.callPackage ./meta-sifive { };

    firefox = final.callPackage ./firefox { };

    # QEMU
    sd-image-qemu = final.callPackage ./sd-image-qemu { };
    sd-image-qemu-sway = final.callPackage ./sd-image-qemu-sway { };

    # HiFive Unmatched
    linux_unmatched = final.callPackage ./linux { };
    linuxPackages_unmatched = final.linuxPackagesFor linux_unmatched;
    uboot-unmatched = final.callPackage ./uboot-unmatched { };

    linux = final.lib.warn "riscv64.linux is deprecated. For HiFive Unmatched, use riscv64.linux_unmatched." linux_unmatched;
    linuxPackages = final.lib.warn "riscv64.linuxPackages is deprecated. For HiFive Unmatched, use riscv64.linuxPackages_unmatched." linuxPackages_unmatched;
  };

  unmatched = final.lib.warn "The unmatched attribute is deprecated. Use riscv64 instead." riscv64;
}
