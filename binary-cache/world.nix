with builtins;

let
  pkgs = import ../nixpkgs {
    overlays = [ (import ../pkgs) ];
  };
  makeWorld = name: contents: pkgs.writeText name (concatStringsSep "\n" contents);

  simpleSystem = (import (pkgs.path + "/nixos") {
    configuration = {
      imports = [
        # All utilities in installer images
        (pkgs.path + "/nixos/modules/profiles/base.nix")
        (pkgs.path + "/nixos/modules/profiles/installation-device.nix")
      ];

      fileSystems."/".device = "fake";
      boot.loader.grub.enable = false;
      networking.useDHCP = false;
      networking.useNetworkd = true;
      services.openssh.enable = true;
    };
  }).system;

  graphicalSystem = (import (pkgs.path + "/nixos") {
    configuration = {
      fileSystems."/".device = "fake";
      boot.loader.grub.enable = false;
      services.xserver.enable = true;
      programs.sway.enable = true;

      # imake/xorg-cf-files doesn't have riscv64 definitions merged
      programs.ssh.askPassword = "";
    };
  }).system;

  cachedLinuxPackagesFor = linuxPackages: map (p: linuxPackages.${p})
    [ "kernel" "zfs" ];
in {
  # Tier 0: Nix, toolchains, etc.
  tier0 = makeWorld "tier0" (with pkgs; [
    nix git stdenv gcc rustc llvmPackages.clang
  ]);

  # Tier 1: Basic system closure and various utilities
  tier1 = makeWorld "tier1" (with pkgs; [
    simpleSystem

    grub2

    cargo doxygen
    gnupg gpgme pcsclite
    gptfdisk udisks
    polkit xdg-utils
    usbutils pciutils mtdutils

    vim tmux wget jq htop pfetch file
    p7zip libarchive
    fish zsh
  ] ++ cachedLinuxPackagesFor riscv64.linuxPackages_unmatched
    ++ cachedLinuxPackagesFor riscv64.linuxPackages_visionfive
    ++ cachedLinuxPackagesFor linuxPackages
    ++ cachedLinuxPackagesFor linuxPackages_5_15
  );

  # Tier 2: Desktop-related and other interesting packages
  tier2 = makeWorld "tier2" (with pkgs; [
    graphicalSystem

    pulseaudio pavucontrol
    mesa-demos
    lynx netsurf.browser
    xterm alacritty kitty
    waypipe
    grim slurp wdisplays
    superTuxKart

    riscv64.firefox
  ]);
}
