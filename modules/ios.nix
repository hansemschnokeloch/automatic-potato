# automatically mount iOS devices

{ config, pkgs, lib, ... }:

lib.mkIf (config.networking.hostName == "ph-thinkstation")
{

  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
    rpiplay
  ];

  # ports for rpiplay
  networking.firewall.allowedTCPPorts = [ 7000 7100 ];
  networking.firewall.allowedUDPPorts = [ 6000 6001 7011 ];
}
