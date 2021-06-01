{ pkgs, lib, linuxPackages_5_12, unmatched, ... } @ args:

let
  sifivePatches = map (patch: {
    name = baseNameOf patch;
    inherit patch;
  }) unmatched.metaSifive.kernelPatches;
in
linuxPackages_5_12.kernel.override({
  kernelPatches = lib.lists.unique (sifivePatches ++ [
    {
      name = "unmatched-config";
      patch = null;
      extraConfig = ''
        SOC_SIFIVE y
        PCIE_FU740 y
        PWM_SIFIVE y
        EDAC_SIFIVE y
        SIFIVE_L2 y

        RISCV_ERRATA_ALTERNATIVE y
        ERRATA_SIFIVE y
        ERRATA_SIFIVE_CIP_453 y
        ERRATA_SIFIVE_CIP_1200 y
      '';
    }
  ]);
})
//
(args.argsOverride or {})
