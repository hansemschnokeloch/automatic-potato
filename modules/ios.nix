# automatically mount iOS devices

{ config, pkgs, lib, ... }:

lib.mkIf (config.networking.hostName == "ph-thinkstation")
{

  services.usbmuxd.enable = true;

  environment.systemPackages = with pkgs; [
    libimobiledevice
    ifuse # optional, to mount using 'ifuse'
  ];

}
