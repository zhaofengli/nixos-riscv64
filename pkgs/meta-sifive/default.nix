# SiFive's patches

{ fetchFromGitHub }: let
  metaSifive = fetchFromGitHub {
    owner = "sifive";
    repo = "meta-sifive";
    rev = "1dd1d1e9896e80f6418b981c57b83c2de76046cb"; # 2022.12
    sha256 = "sha256-RvycCbrBaO+VPxEm5OJEEMw9B5WYmBrpj91OUN0rQWw=";
  };
in {
  ubootPatches = map (patch: "${metaSifive}/recipes-bsp/u-boot/files/riscv64/${patch}") [
    "0002-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch"
    "0003-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch"
    "0004-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch"
    "0005-board-sifive-spl-Set-remote-thermal-of-TMP451-to-85-.patch"
    "0008-riscv-dts-Add-few-PMU-events.patch"
  ];
  kernelPatches = map (patch: "${metaSifive}/recipes-kernel/linux/files/${patch}") [
    "0001-riscv-sifive-fu740-cpu-1-2-3-4-set-compatible-to-sif.patch"
    #"0003-riscv-sifive-unmatched-define-PWM-LEDs.patch"
    "0005-SiFive-HiFive-Unleashed-Add-PWM-LEDs-D1-D2-D3-D4.patch"
    "Revert-riscv-dts-sifive-unmatched-Link-the-tmp451-wi.patch"
  ];
}
