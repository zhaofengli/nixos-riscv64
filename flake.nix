{
  description = "Board-Specific Packages for NixOS on RISC-V";

  inputs = {
    nixpkgs.url = "github:zhaofengli/nixpkgs/riscv";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {
      system = "riscv64-linux";
      overlays = [ self.overlay ];
    };
  in {
    overlay = import ./pkgs;
    legacyPackages.riscv64-linux = pkgs;
    nixosModules.unmatched = ./nixos/unmatched.nix;
  };
}
