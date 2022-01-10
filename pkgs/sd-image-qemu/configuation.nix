{ config, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-riscv64-qemu.nix")
  ];

  nix.binaryCaches = [ "https://unmatched.cachix.org" ];
  nix.binaryCachePublicKeys = [ "unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc=" ];
}
