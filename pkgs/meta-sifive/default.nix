# SiFive's patches

{ fetchFromGitHub }: let
  metaSifive = fetchFromGitHub {
    owner = "sifive";
    repo = "meta-sifive";
    rev = "1340b6018b87263fa6c28072ddd0a9d0ac3a849e";
    sha256 = "1pbamywniiqg3jy3sj9r63qhs8jamwd8py431zk5hlnnks8hfrvy";
  };
in {
  ubootPatches = map (patch: "${metaSifive}/recipes-bsp/u-boot/files/unmatched/${patch}") [
    "0001-clk-sifive-fu540-prci-Extract-prci-core-to-common-ba.patch"
    "0002-clk-sifive-fu540-prci-Use-common-name-for-prci-confi.patch"
    "0003-clk-sifive-fu740-Sync-up-DT-bindings-header-with-ups.patch"
    "0004-clk-sifive-fu740-prci-Add-a-driver-for-the-SiFive-FU.patch"
    "0005-clk-sifive-select-PLL-clock-as-input-source-after-en.patch"
    "0006-clk-sifive-fu740-prci-set-HFPCLKPLL-rate-to-260-Mhz.patch"
    "0007-riscv-dts-Add-SiFive-FU740-C000-SoC-dts-from-Linux.patch"
    "0008-riscv-dts-Add-hifive-unmatched-a00-dts-from-Linux.patch"
    "0009-riscv-cpu-fu740-Add-support-for-cpu-fu740.patch"
    "0010-riscv-Add-SiFive-HiFive-Unmatched-FU740-board-suppor.patch"
    "0011-riscv-sifive-dts-fu740-Add-board-u-boot.dtsi-files.patch"
    "0012-dt-bindings-sifive-fu740-add-indexes-for-reset-signa.patch"
    "0013-fu740-dtsi-add-reset-producer-and-consumer-entries.patch"
    "0014-ram-sifive-Add-common-DDR-driver-for-sifive.patch"
    "0015-ram-sifive-Added-compatible-string-for-FU740-c000-dd.patch"
    "0016-sifive-dts-fu740-Add-DDR-controller-and-phy-register.patch"
    "0017-riscv-sifive-dts-fu740-add-U-Boot-dmc-node.patch"
    "0018-riscv-sifive-hifive_unmatched_fu740-add-SPL-configur.patch"
    "0019-sifive-hifive_unmatched_fu740-Add-sample-SD-gpt-part.patch"
    "0020-sifive-fu740-Add-U-Boot-proper-sector-start.patch"
    "0021-configs-hifive_unmatched_fu740-Add-config-options-fo.patch"
    "0022-riscv-sifive-fu540-enable-all-cache-ways-from-U-Boot.patch"
    "0023-riscv-sifive-dts-fu740-set-ethernet-clock-rate.patch"
    "0024-sifive-fu740-set-kernel_comp_addr_r-and-kernel_comp_.patch"
    "0025-sifive-fu740-enable-full-L2-cache-ways-16-ways-total.patch"
    "0026-sifive-fu740-fix-cache-controller-signals-order.patch"
    "0027-sifive-fu740-change-eth0-assigned-clock-rates-to-125.patch"
    "0028-sifive-hifive_unmatched_fu740-Enable-64bit-PCI-resou.patch"
    "0029-clk-sifive-add-pciaux-clock.patch"
    "0030-pci-sifive-add-pcie-driver-for-fu740.patch"
    "0031-Update-SiFive-Unmatched-defconfig.patch"
    "0032-riscv-sifive-unmatched-set-cacheline-size-to-64-byte.patch"
    "0033-fu740-add-CONFIG_CMD_GPT-and-CONFIG_CMD_GPT_RENAME.patch"
    "0034-Unmathced-FU740-add-NVME-USB-and-PXE-to-boot-targets.patch"
    "0035-riscv-clear-feature-disable-CSR.patch"
    "0036-riscv-sifive-unmatched-add-I2C-EEPROM.patch"
    "0037-cmd-Add-a-pwm-command.patch"
    "0038-cmd-pwm-Rework-argc-sanity-checking.patch"
    "0039-riscv-sifive-unmatched-enable-PWM.patch"
    "0040-riscv-sifive-unmatched-update-for-rev3-16GB-1866.patch"
    "0041-Fix-CRC32-checksum-for-SiFive-HiFive-EEPROM.patch"
    "0042-riscv-sifive-unmatched-add-gpio-poweroff.patch"
    "0043-board-sifive-spl-refine-GEMGXL-initialized-function.patch"
    "0044-board-sifive-spl-reset-USB-hub-PCIe-USB-bridge-and-U.patch"
    "0045-board-sifive-spl-Initialized-the-PWM-setting-in-the-.patch"
    "0046-board-sifive-Set-LED-s-color-to-purple-in-the-U-boot.patch"
    "0047-board-sifive-Set-LED-s-color-to-blue-before-jumping-.patch"
    "0048-pwm-sifive-ensure-the-pwm_ops.set_config-and-.set_en.patch"
    "0049-riscv-sifive-fu740-kconfig-Enable-support-for-Openco.patch"
    "0050-riscv-sifive-fu740-Support-i2c-in-spl.patch"
    "0051-board-sifive-Add-an-interface-to-get-PCB-revision.patch"
    "0052-riscv-sifive-unmatched-set-default-clock-to-1.2GHz.patch"
  ];
  opensbiPatches = map (patch: "${metaSifive}/recipes-bsp/opensbi/files/${patch}") [
    "0001-Makefile-Don-t-specify-mabi-or-march.patch"
    "unmatched/0001-lib-utils-add-GPIO-and-poweroff-parsing.patch"
    "unmatched/0002-lib-utils-add-gpio-generic-interface.patch"
    "unmatched/0003-lib-utils-reset-add-powor-off-support.patch"
  ];
}
