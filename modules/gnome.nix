{ config, lib, pkgs, ... }:

let
  mkExtension = name: pkgs.gnomeExtensions.${name};
in

{
  # Enable the X11 windowing system.
  services.xserver = {
    enable = true;
    desktopManager.gnome.enable = true;
    displayManager.gdm.enable = true;
    # Configure keymap in X11
    layout = "fr";
    xkbVariant = "azerty";
    # Remove useless software
    excludePackages = [ pkgs.xterm ];
  };

  environment.systemPackages = with pkgs; with pkgs.gnome; [
    gnome-tweaks
    gnome-firmware
    gnome-screenshot
    evolution
  ] ++ (builtins.map mkExtension [
    "clipboard-indicator"
    "vitals"
    "hot-edge"
    "run-or-raise"
    "auto-move-windows"
    "notification-banner-position"
    "tweaks-in-system-menu"
  ]);

  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-photos
    gnome-connections
    gnome-console
    gnome.cheese
    gnome.geary
    epiphany
  ];
}

