{ lib, stdenv, fetchFromGitHub, buildLinux, ... } @ args:

buildLinux (args // {
  version = "5.16.11";

  src = fetchFromGitHub {
    owner = "starfive-tech";
    repo = "linux";
    rev = "d7f399d52baa99c715f257707040573768ba3d97";
    sha256 = "sha256-Xi0sNUrLL7fCnDc5w+mxYJCwiPFaamdvJmKfvbP7ZbY=";
  };

  defconfig = "starfive_jh7100_fedora_defconfig";

  extraConfig = ''
    DW_AXI_DMAC_STARFIVE y
  '';
}) // (args.argsOverride or {})
