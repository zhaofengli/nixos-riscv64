self: super: {
  unmatched = {
    metaSifive = super.callPackage ./meta-sifive { };
    opensbi = super.callPackage ./opensbi { };
    uboot = super.callPackage ./uboot { };
    ubootQemu = super.callPackage ./uboot-qemu { };
  };
}
