{ config, pkgs, lib, ... }:

{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;

    settings = {
      format = lib.concatStrings [
        "$directory"
        "$git_branch"
        "$git_status"
        "$nix_shell"
        "$cmd_duration"
        "$line_break"
        "$character"
      ];

      directory = {
        style = "bold cyan";
        truncation_length = 3;
        truncate_to_repo = true;
      };

      git_branch = {
        style = "bold purple";
        format = "[$symbol$branch]($style) ";
        symbol = " ";
      };

      git_status = {
        style = "bold red";
        format = "[$all_status$ahead_behind]($style)";
        conflicted = "=";
        ahead = "⇡\${count}";
        behind = "⇣\${count}";
        diverged = "⇕⇡\${ahead_count}⇣\${behind_count}";
        untracked = "?\${count}";
        stashed = "*";
        modified = "!\${count}";
        staged = "+\${count}";
        renamed = "»";
        deleted = "✘";
      };

      nix_shell = {
        style = "bold blue";
        format = "[$symbol$state]($style) ";
        symbol = " ";
        impure_msg = "";
        pure_msg = "pure";
      };

      cmd_duration = {
        style = "bold yellow";
        format = "[$duration]($style) ";
        min_time = 2000;
        show_milliseconds = false;
      };

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol = "[❯](bold red)";
        vimcmd_symbol = "[❮](bold green)";
      };
    };
  };
}
