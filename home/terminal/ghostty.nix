{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

let
  # Wrap ghostty with LIBGL_ALWAYS_SOFTWARE=1 so Mesa's llvmpipe provides
  # OpenGL 4.6, which satisfies Ghostty's ≥4.3 requirement on the X220's
  # Intel HD 3000 (hardware GL tops out at 3.3).
  ghosttyWrapped = pkgs.writeShellScriptBin "ghostty" ''
    export LIBGL_ALWAYS_SOFTWARE=1
    exec ${lib.getExe pkgs.ghostty} "$@"
  '';
in
{
  programs.ghostty = {
    enable = true;
    package = null; # we provide our own wrapper
    systemd.enable = false;
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

  home.packages = [ ghosttyWrapped ];

  xdg.configFile."ghostty/custom.css".source = ./ghostty-custom.css;
}
