{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ../pkgs)
  ];

  hardware.deviceTree.name = "starfive/jh7100-starfive-visionfive-v1.dtb";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.riscv64.linuxPackages_visionfive;
  boot.kernelParams = [ "console=tty0" "console=ttyS0,115200" "earlycon=sbi" ];
  boot.initrd.kernelModules = [ "dw-axi-dmac-platform" "dw_mmc-pltfm" "spi-dw-mmio" ];

  systemd.services."serial-getty@hvc0" = {
    enable = false;
  };

  environment.systemPackages = with pkgs; [
    mtdutils
  ];
}
