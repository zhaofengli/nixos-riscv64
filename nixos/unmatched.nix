{ pkgs, ... }: {
  nixpkgs.overlays = [
    (import ../pkgs)
  ];

  hardware.deviceTree.name = "sifive/hifive-unmatched-a00.dtb";

  boot.loader.grub.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  boot.kernelPackages = pkgs.unmatched.linuxPackages;
  boot.initrd.kernelModules = [ "nvme" "mmc_block" "mmc_spi" "spi_sifive" "spi_nor" ];

  environment.systemPackages = with pkgs; [
    mtdutils
  ];
}
