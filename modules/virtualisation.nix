{ config, pkgs, ... }:

let
  unstable = import <nixos-unstable> { config = { allowUnfree = true; }; };
in
{
  # vmware
  disabledModules = [ "virtualisation/vmware-host.nix" ];
  imports = [ <nixos-unstable/nixos/modules/virtualisation/vmware-host.nix> ];
  virtualisation.vmware.host = {
    enable = true;
    package = unstable.vmware-workstation;
  };

  # docker
  virtualisation.docker.enable = true;
  virtualisation.docker.rootless.enable = true;
  virtualisation.docker.enableOnBoot = false;

  services.usbmuxd.enable = true;
}
