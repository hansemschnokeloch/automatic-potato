{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    initExtra = "export PATH=$HOME/.local/bin:$PATH";
    shellAliases = {
      icat = "kitty +kitten icat";
      p = "/home/pascal/.local/bin/bookmarks.sh";
      vi = "nvim";
      c = "php bin/console";
      dep = "php vendor/bin/dep";
      ls = "exa";
    };
    oh-my-zsh = {
      enable = true;
      custom = "$HOME/.oh-my-zsh-custom";
      plugins = [ "fzf" "timewarrior" ];
      theme = "agnoster";
    };
  };
}
