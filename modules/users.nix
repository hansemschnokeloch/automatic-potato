{ config, pkgs, ... }:

{
  # users
  users.users.pascal = {
    isNormalUser = true;
    description = "pascal";
    extraGroups = [ "networkmanager" "wheel" "docker" "lp" "scanner" ];
  };

  environment.variables.EDITOR = "nvim";
  programs.zsh.enable = true;
  users.defaultUserShell = pkgs.zsh;

  # syncthing
  services.syncthing = {
    enable = true;
    user = "pascal";
    dataDir = "/home/pascal";
    configDir = "/home/pascal/.config/syncthing";
  };

  # home-manager
  home-manager = {
    useGlobalPkgs = true;
    users.pascal = import ./../home-manager;
  };
}

