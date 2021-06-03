self: super: {
  unmatched = rec {
    metaSifive = super.callPackage ./meta-sifive { };

    linux = super.callPackage ./linux { };
    linuxPackages = super.linuxPackagesFor linux;

    opensbi = super.callPackage ./opensbi { };
    uboot = super.callPackage ./uboot { };
    ubootQemu = super.callPackage ./uboot-qemu { };
  };

  mesa = if super.stdenv.hostPlatform.isRiscV then super.mesa.override {
    driDrivers = [ "r100" "r200" "nouveau" ];
    galliumDrivers = [ "r300" "r600" "radeonsi" "nouveau" "virgl" "swrast" ];
    vulkanDrivers = [ "amd" "swrast" ];
  } else super.mesa;
}
