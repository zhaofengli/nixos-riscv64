# TODO: Consolidate with sd-image-riscv64-unmatched

{ lib, nixos, nix-gitignore, runCommandLocal
, nixos-riscv64 ? nix-gitignore.gitignoreSource [] ../.. }:

let
  riscv64Channel = runCommandLocal "nixos-riscv64" {} ''
    mkdir -p $out
    cp -prd ${nixos-riscv64} $out/nixos-riscv64
  '';

  config = { lib, pkgs, modulesPath, config, ... }: {
    imports = [
      ./sd-image-riscv64-visionfive.nix
      ../../nixos/visionfive.nix
    ];

    sdImage.imageName = "nixos-sd-image-visionfive";

    boot.postBootCommands = lib.mkAfter ''
      # Copy nixos-riscv64 channel
      if ! [ -e /var/lib/nixos/did-nixos-riscv64-channel-init ]; then
        echo "unpacking the nixos-riscv64 channel..."
        mkdir -p /nix/var/nix/profiles/per-user/root
        ${config.nix.package.out}/bin/nix-env -p /nix/var/nix/profiles/per-user/root/channels \
          -i ${riscv64Channel} --quiet --option build-use-substitutes false
        mkdir -m 0755 -p /var/lib/nixos
        touch /var/lib/nixos/did-nixos-riscv64-channel-init
      fi

      # To facilitate nixos-rebuild
      if [[ ! -e /etc/nixos/configuration.nix ]]; then
        cp ${./configuation.nix} /etc/nixos/configuration.nix
      fi
    '';
  };
  eval = nixos config;
in eval.config.system.build.sdImage
