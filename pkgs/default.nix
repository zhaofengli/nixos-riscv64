final: prev: {
  unmatched = rec {
    metaSifive = final.callPackage ./meta-sifive { };

    sdImageQemu = final.callPackage ./sd-image-qemu { };

    linux = final.callPackage ./linux { };
    linuxPackages = final.linuxPackagesFor linux;

    uboot = final.callPackage ./uboot { };
    firefox = final.callPackage ./firefox { };
  };
}
