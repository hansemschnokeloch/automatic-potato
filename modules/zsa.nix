# ZSA keyboard configuration

{ config, pkgs, ... }:

{
  # enable ZSA keyboards
  hardware.keyboard.zsa.enable = true;
  environment.systemPackages = with pkgs; [
    wally-cli # ZSA keyboard firmware loader
  ];

}
