{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ../pkgs)
  ];

  hardware.deviceTree.name = "sifive/hifive-unmatched-a00.dtb";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.riscv64.linuxPackages_unmatched;
  boot.kernelParams = [ "console=tty0" "console=ttySIF0,115200" "earlycon=sbi" ];
  boot.initrd.kernelModules = [ "nvme" "mmc_block" "mmc_spi" "spi_sifive" "spi_nor" ];

  systemd.services."serial-getty@hvc0" = {
    enable = false;
  };

  environment.systemPackages = with pkgs; [
    mtdutils
  ];
}
