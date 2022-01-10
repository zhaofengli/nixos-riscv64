self: super: {
  unmatched = rec {
    metaSifive = super.callPackage ./meta-sifive { };

    linux = super.callPackage ./linux { };
    linuxPackages = super.linuxPackagesFor linux;

    uboot = super.callPackage ./uboot { };
  };
}
