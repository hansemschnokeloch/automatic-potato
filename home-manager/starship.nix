{ pkgs, ... }:

{
  programs.starship = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      character = {
        success_symbol = "[➜](bold green) ";
        error_symbol = "[✗](bold red) ";
      };
      time = {
        disabled = false;
        format = "[$time](bold green) ";
        time_format = "%T";
      };
      git_branch = {
        format = "\\[[$symbol$branch]($style)\\]";
        style = "bold blue";
      };
      git_status = {
        format = "\\[[$all_status$ahead_behind]($style)\\]";
        renamed = "➜ ";
        modified = "! ";
        deleted = " ";
        staged = "+ ";
        ahead = "⇡ ";
        diverged = "⇕⇡$ahead_count⇣$behind_count";
        behind = "⇣ ";
        style = "bold 142";
      };
      php = {
        disabled = false;
      };
      shlvl = {
        disabled = false;
        symbol = "🧅 ";
        format = "$symbol";
      };
      custom.timew = {
        disabled = false;
        command = "timew | head -1 | awk '{print $(NF-1), $NF}'";
        symbol = "⏳ ";
        when = "timew | grep Tracking";
        format = "\\[[$output](yellow)\\]";
      };
    };
  };
}
