{
  description = "Board-Specific Packages for NixOS on RISC-V";

  inputs = {
    nixpkgs.url = "github:zhaofengli/nixpkgs/riscv";
  };

  outputs = { self, nixpkgs }: let
    pkgs = import nixpkgs {
      system = "riscv64-linux";
      overlays = [
        (final: prev: {
          nixos-riscv64 = self.outPath;
        })

        self.overlay
      ];
    };
  in {
    overlay = import ./pkgs;
    legacyPackages.riscv64-linux = pkgs;
    nixosModules.unmatched = import ./nixos/unmatched.nix;
  };
}
