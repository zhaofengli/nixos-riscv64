self: super: {
  unmatched = rec {
    metaSifive = super.callPackage ./meta-sifive { };

    linux = super.callPackage ./linux { };
    linuxPackages = super.linuxPackagesFor linux;

    opensbi = super.callPackage ./opensbi { };
    uboot = super.callPackage ./uboot { };
    ubootQemu = super.callPackage ./uboot-qemu { };
  };
}
