{ config, pkgs, modulesPath, ... }:
{
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-riscv64-qemu.nix")
  ];

  nixpkgs.overlays = [
    (import <nixos-riscv64/pkgs>)
  ];

  hardware.pulseaudio.enable = true;

  services.xserver = {
    enable = true;

    # For OOBE - You may want to disable the following
    displayManager.autoLogin = {
      enable = true;
      user = "nixos";
    };

    displayManager.lightdm = {
      enable = true;
      greeter.enable = false;
      autoLogin.timeout = 0;
    };
  };

  programs.sway = {
    enable = true;
    extraSessionCommands = ''
      export WLR_RENDERER_ALLOW_SOFTWARE=1
    '';
  };

  environment.systemPackages = with pkgs; [
    riscv64.firefox
    superTuxKart
    glxinfo
    kitty
    pavucontrol
  ];

  # imake/xorg-cf-files doesn't have riscv64 definitions merged
  programs.ssh.askPassword = "";

  nix.settings.substituters = [
    "https://cache.nixos.org"
    "https://beam.attic.rs/riscv"
  ];
  nix.settings.trusted-public-keys = [
    "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    "riscv:TZX1ReuoIGt7QiSQups+92ym8nKJUSV0O2NkS4HAqH8="
  ];
}
