{ lib, buildUBoot, fetchFromGitHub, unmatched }: buildUBoot {
  version = "2021.01";
  src = fetchFromGitHub {
    owner = "u-boot";
    repo = "u-boot";
    rev = "v2021.01";
    sha256 = "122lxr55apad9jb81074z1k8rlyhrz8mbz5y48y3dwkcycn393xl";
  };

  defconfig = "sifive_hifive_unmatched_fu740_defconfig";

  extraMeta.platforms = [ "riscv64-linux" ];
  extraPatches = unmatched.metaSifive.ubootPatches;
  extraMakeFlags = [
    "OPENSBI=${unmatched.opensbi}/share/opensbi/lp64/generic/firmware/fw_dynamic.bin"
  ];

  filesToInstall = [ "u-boot.itb" "spl/u-boot-spl.bin" ];
}
