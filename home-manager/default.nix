{ ... }:

{
  imports = [
    ./git.nix
    ./bash.nix
    ./zsh.nix
    ./starship.nix
    ./direnv.nix
  ];

  home.stateVersion = "18.09";
}
