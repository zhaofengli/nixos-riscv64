{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    mtdutils
  ];
}
