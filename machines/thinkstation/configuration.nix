#########################################################
# Configuration file for Lenovo ThinkStation P350 Tiny
# CPU 11th Gen Intel i9-11900T (16) @ 4.800GHz 
# GPU Intel RocketLake-S GT1 [UHD Graphics 750] 
# GPU NVIDIA T600 
# Memory: 31773MiB
#########################################################

{ config, pkgs, lib, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./nix.nix
    ./packages.nix

    ./../../modules/users.nix
    ./../../modules/fonts.nix
    ./../../modules/gnome.nix
    ./../../modules/ios.nix
    ./../../modules/virtualisation.nix
    ./../../modules/packages.nix

    ./../../devices/samsung-clx3185.nix

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
  networking.hostName = "ph-thinkstation";
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

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

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
