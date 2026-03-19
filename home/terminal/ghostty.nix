{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = theme.ghostty;
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      shell-integration = "nushell";
      command = "nu";
      window-decoration = false;
      background-opacity = 0.85;
      gtk-custom-css = "${config.xdg.configHome}/ghostty/custom.css";
    };
  };

  xdg.configFile."ghostty/custom.css".source = ./ghostty-custom.css;
}
