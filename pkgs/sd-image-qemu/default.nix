{ nixos }:

let
  config = { pkgs, modulesPath, ... }: {
    imports = [
      (modulesPath + "/installer/sd-card/sd-image-riscv64-qemu-installer.nix")
      ./configuation.nix
    ];

    # To facilitate nixos-rebuild
    boot.postBootCommands = ''
      if [[ ! -e /etc/nixos/configuration.nix ]]; then
        cp ${./configuation.nix} /etc/nixos/configuration.nix
      fi
    '';
  };
  eval = nixos config;
in eval.config.system.build.sdImage
