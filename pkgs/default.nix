final: prev: {
  unmatched = rec {
    meta-sifive = final.callPackage ./meta-sifive { };

    sd-image-qemu = final.callPackage ./sd-image-qemu { };

    linux = final.callPackage ./linux { };
    linuxPackages = final.linuxPackagesFor linux;

    uboot = final.callPackage ./uboot { };
    firefox = final.callPackage ./firefox { };
  };
}
