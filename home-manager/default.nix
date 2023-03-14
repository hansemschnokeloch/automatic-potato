{ pkgs, ... }:

{
  imports = [
    ./git.nix
    ./bash.nix
    ./zsh.nix
    ./starship.nix
  ];
}
