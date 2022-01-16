{ config, pkgs, modulesPath, ... }:
let
  mesa-patched = pkgs.mesa.overrideAttrs (old: {
    patches = (old.patches or []) ++ [
      ./gallivm-riscv.patch
    ];
  });
in {
  imports = [
    (modulesPath + "/installer/sd-card/sd-image-riscv64-qemu.nix")
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
    unmatched.firefox
    superTuxKart
    glxinfo
    kitty
  ];

  system.replaceRuntimeDependencies = [
    {
      original = pkgs.mesa;
      replacement = mesa-patched;
    }
    {
      original = pkgs.mesa.drivers;
      replacement = mesa-patched.drivers;
    }
  ];

  # imake/xorg-cf-files doesn't have riscv64 definitions merged
  programs.ssh.askPassword = "";

  nix.binaryCaches = [ "https://unmatched.cachix.org" ];
  nix.binaryCachePublicKeys = [ "unmatched.cachix.org-1:F8TWIP/hA2808FDABsayBCFjrmrz296+5CQaysosTTc=" ];
}
