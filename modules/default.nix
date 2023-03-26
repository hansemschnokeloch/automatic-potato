{ pkgs, ... }:

{
  imports = [
    ./dev.nix # local dev stack
    ./fonts.nix
    ./gnome.nix
    ./ios.nix
    ./nix.nix # nix settings - gc etc
    ./packages.nix # common packages
    ./sane.nix # sane config to use with samsung scanner
    ./samsung-clx3185.nix
    ./sound.nix
    ./users.nix
    ./vmware.nix
    ./zsa.nix # zsa keybord stuff
  ];
}
