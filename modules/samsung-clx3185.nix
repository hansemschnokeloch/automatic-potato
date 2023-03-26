{ config, pkgs, ... }:

let
  vuescan = pkgs.callPackage ./../pkgs/vuescan.nix { };
in

{
  # Enable CUPS to print documents.
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.samsung-unified-linux-driver_1_00_37 ];
  # Enable scanner support
  hardware.sane.enable = true;
  services.avahi.enable = true;
  services.avahi.nssmdns = true;
  services.avahi.openFirewall = true;
  networking.firewall.allowedUDPPorts = [ 5353 ];
  # disable module and import local version
  disabledModules = [ "services/hardware/sane.nix" ];
  imports = [ ./../modules/sane.nix ];
  # vuescan
  services.udev.packages = [ vuescan ];
  environment.systemPackages = [ vuescan ];
}

