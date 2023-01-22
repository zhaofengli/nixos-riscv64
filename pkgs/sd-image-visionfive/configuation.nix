{ config, pkgs, modulesPath, ... }:
{
  imports = [
    (import <nixos-riscv64/pkgs/sd-image-visionfive/sd-image-riscv64-visionfive.nix>)
    (import <nixos-riscv64/nixos/visionfive.nix>)
  ];

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://beam.attic.rs/riscv"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "riscv:TZX1ReuoIGt7QiSQups+92ym8nKJUSV0O2NkS4HAqH8="
  ];
}
