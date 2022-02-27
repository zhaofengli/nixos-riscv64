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

  structuredExtraConfig = with lib.kernel; {
    SERIAL_8250_DW = yes;
    PINCTRL_STARFIVE = yes;

    # Doesn't build as a module
    DW_AXI_DMAC_STARFIVE = yes;

    # stmmac hangs when built as a module
    PTP_1588_CLOCK = yes;
    STMMAC_ETH = yes;
    STMMAC_PCI = yes;
  };
}) // (args.argsOverride or {})
