{ lib, buildUBoot, fetchFromGitHub, fetchpatch, opensbi, overclock ? true, riscv64 }: buildUBoot rec {
  version = "2022.01";
  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "v${version}";
    sha256 = "sha256-kKxo62/TI0HD8uZaL39FyJc783JsErkfspKsQ6uvEMU=";
  };

  defconfig = "sifive_unmatched_defconfig";

  extraMeta.platforms = [ "riscv64-linux" ];
  extraPatches = riscv64.meta-sifive.ubootPatches
    ++ lib.optional overclock ./overclock.patch;
  extraMakeFlags = [
    "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  filesToInstall = [ "u-boot.itb" "spl/u-boot-spl.bin" ];
}
