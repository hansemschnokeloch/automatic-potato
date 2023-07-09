{ pkgs, config, ... }:

{
  # allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
    # to be able to configure binary cache as user pascal
    trusted-users = [ "root" "pascal" ];
    # relaxed to allow the use of __noChroot = true option in derivations
    # sandbox = "relaxed";
  };
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 30d";
  };
  environment.systemPackages = with pkgs; [
    appimage-run # nixos appimage runner
    nixos-option # nixos options viewer
    cachix # nix binary cache
  ];

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leavecatenate(variables, "bootdev", bootdev)
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "22.05"; # Did you read the comment?
}
