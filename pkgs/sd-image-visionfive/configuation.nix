{ config, pkgs, modulesPath, ... }:
{
  imports = [
    (import <nixos-riscv64/pkgs/sd-image-visionfive/sd-image-riscv64-visionfive.nix>)
    (import <nixos-riscv64/nixos/visionfive.nix>)
  ];

  nix.binaryCaches = [ "https://unmatched.cachix.org" ];
  nix.binaryCachePublicKeys = [ "unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc=" ];
}
