final: prev: {
  unmatched = rec {
    metaSifive = final.callPackage ./meta-sifive { };

    linux = final.callPackage ./linux { };
    linuxPackages = final.linuxPackagesFor linux;

    uboot = final.callPackage ./uboot { };
  };
}
