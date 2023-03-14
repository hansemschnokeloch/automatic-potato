{ pkgs, ... }:

let
  mkDot = list: (builtins.concatStringsSep "." list);
  mkEmail = name: domain: (mkDot name) + "@" + (mkDot domain);
  emails = {
    SARL = mkEmail [ "sarl" ] [ "hubrecht" "info" ];
  };
in

{
  programs.git = {
    enable = true;
    userEmail = emails.SARL;
    aliases = {
      lg = "log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit --date=relative";
      st = "status --short --branch";
    };
    extraConfig = {
      pull.rebase = false;
      init.defaultBranch = "main";
    };
    ignores = [ ".container" ];
  };
}
