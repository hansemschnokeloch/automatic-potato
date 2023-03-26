{ pkgs, ... }:

{
  imports = [
    ./dev.nix # local dev stack
    ./fonts.nix
    ./gnome.nix
    ./ios.nix
    ./nix.nix # nix settings - gc etc
    ./packages.nix # common packages
    ./sound.nix
    ./users.nix
    ./vmware.nix
    ./zsa.nix # zsa keybord stuff
  ];
}
