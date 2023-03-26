{ config, pkgs, lib, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in

{
  # vmware
  disabledModules = [ "virtualisation/vmware-host.nix" ];
  imports = [ <nixos-unstable/nixos/modules/virtualisation/vmware-host.nix> ];

  virtualisation.vmware.host = lib.mkIf (config.networking.hostName == "ph-thinkstation") {
    enable = true;
    package = unstable.vmware-workstation;
  };
}

