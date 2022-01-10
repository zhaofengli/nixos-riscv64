{ lib, buildUBoot, fetchFromGitHub, opensbi, overclock ? true, unmatched }: buildUBoot rec {
  version = "2021.10";
  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "v${version}";
    sha256 = "sha256-2CcIHGbm0HPmY63Xsjaf/Yy78JbRPNhmvZmRJAyla2U=";
  };

  defconfig = "sifive_unmatched_defconfig";

  extraMeta.platforms = [ "riscv64-linux" ];
  extraPatches = unmatched.metaSifive.ubootPatches
    ++ lib.optional overclock ./overclock.patch
  extraMakeFlags = [
    "OPENSBI=${opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  filesToInstall = [ "u-boot.itb" "spl/u-boot-spl.bin" ];
}
