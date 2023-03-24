{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    enableZshIntegration = true;
    nix-direnv.enable = true;
    config = {
      whitelist = {
        prefix = [ "$HOME/Data/_DEV" "/var/www/" ];
      };
    };
  };
}
