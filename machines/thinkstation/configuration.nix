#########################################################
# Configuration file for Lenovo ThinkStation P350 Tiny
# CPU 11th Gen Intel i9-11900T (16) @ 4.800GHz 
# GPU Intel RocketLake-S GT1 [UHD Graphics 750] 
# GPU NVIDIA T600 
# Memory: 31773MiB
#########################################################

{ config, pkgs, lib, ... }:

let
  hostName = "ph-thinkstation";
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
      efiSysMountPoint = "/boot/efi";
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

  # Nvidia
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.opengl.enable = true;
  hardware.nvidia.package = config.boot.kernelPackages.nvidiaPackages.stable;

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
