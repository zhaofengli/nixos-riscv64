{ pkgs, lib, linuxPackages_5_15, unmatched, ... } @ args:

let
  sifivePatches = map (patch: {
    name = baseNameOf patch;
    inherit patch;
  }) unmatched.meta-sifive.kernelPatches;
in
linuxPackages_5_15.kernel.override({
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
    {
      name = "unmatched-cpufreq";
      patch = null;
      extraConfig = ''
        CPU_IDLE y
        CPU_FREQ y
        CPU_FREQ_DEFAULT_GOV_USERSPACE y
        CPU_FREQ_GOV_PERFORMANCE y
        CPU_FREQ_GOV_USERSPACE y
        CPU_FREQ_GOV_ONDEMAND y
      '';
    }
  ]);
})
//
(args.argsOverride or {})
