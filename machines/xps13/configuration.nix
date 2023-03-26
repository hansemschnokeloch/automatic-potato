#########################################################
# Configuration file for Dell XPS 13 plus 9520
# CPU 12th Gen Intel i7-1260P (16) @ 4.700GHz 
# Memory: 31719MiB
#########################################################

{ config, pkgs, lib, ... }:

let
  hostName = "ph-xps13";
in

{
  imports = [
    ./hardware-configuration.nix
    ./packages.nix # specific packages
    ./../../modules
    <home-manager/nixos>
  ];

  # Firmware update
  services.fwupd.enable = true;

  # Bootloader.
  boot.loader = {
    systemd-boot.configurationLimit = 20;
    systemd-boot.enable = true;
    efi = {
      canTouchEfiVariables = true;
    };
  };

  # networking
  networking.networkmanager.enable = true;
  networking.hostName = hostName;
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Set your time zone.
  time.timeZone = "Europe/Paris";
  # Select internationalisation properties.
  i18n.defaultLocale = "fr_FR.utf8";
  # Configure console keymap
  console.keyMap = "fr";

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;
}
