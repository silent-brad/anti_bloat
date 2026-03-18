{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "ghostty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
    };
    theme = let
      inherit (config.lib.formats.rasi) mkLiteral;
    in {
      "*" = {
        bg = mkLiteral theme.bg;
        fg = mkLiteral theme.fg;
        accent = mkLiteral theme.accent;
        surface = mkLiteral theme.surface;
        background-color = mkLiteral theme.bg;
        text-color = mkLiteral theme.fg;
      };
      window = {
        width = mkLiteral "40%";
        border = mkLiteral "2px";
        border-color = mkLiteral theme.accent;
        border-radius = mkLiteral "8px";
      };
      inputbar = {
        padding = mkLiteral "8px";
        background-color = mkLiteral theme.surface;
      };
      prompt = {
        text-color = mkLiteral theme.accent;
      };
      entry = {
        placeholder = "Search...";
      };
      listview = {
        lines = 8;
        padding = mkLiteral "4px";
      };
      element = {
        padding = mkLiteral "6px 8px";
        border-radius = mkLiteral "4px";
      };
      "element selected" = {
        background-color = mkLiteral theme.accent;
        text-color = mkLiteral theme.bg;
      };
    };
  };
}
