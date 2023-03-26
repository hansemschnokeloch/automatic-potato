{ config, lib, pkgs, modulesPath, ... }:

let
  unstable = import <nixos-unstable> {
    config = {
      allowUnfree = true;
    };
  };
in

{
  imports =
    [
      (modulesPath + "/installer/scan/not-detected.nix")
    ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  # using kernel from unstable in order to get the modules for unstable.vmware
  boot.kernelPackages = unstable.pkgs.linuxKernel.packages.linux_6_1;
  boot.extraModulePackages = [ ];
  boot.kernelParams = [ ];
  boot.loader.systemd-boot.consoleMode = "keep";

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/f9474120-6d1c-48d7-859e-f6cbe455e453";
      fsType = "btrfs";
      options = [ "subvol=@" ];
    };

  fileSystems."/boot/efi" =
    {
      device = "/dev/disk/by-uuid/EC8D-052C";
      fsType = "vfat";
    };

  fileSystems."/home" =
    {
      device = "/dev/disk/by-uuid/13c6fd54-6337-43ce-afac-c304529fac93";
      fsType = "btrfs";
    };
  fileSystems."/var/www" =
    {
      device = "/dev/disk/by-uuid/13c6fd54-6337-43ce-afac-c304529fac93";
      fsType = "btrfs";
      options = [ "subvol=dev" ];
    };

  swapDevices = [ ];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.eno2.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  powerManagement.cpuFreqGovernor = lib.mkDefault "powersave";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
  # high-resolution display
  hardware.video.hidpi.enable = lib.mkDefault true;
}
