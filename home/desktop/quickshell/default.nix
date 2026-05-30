{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

let
  dependencies = with pkgs; [
    bash
    nushell
    coreutils
    gawk
    jq
    curl
    networkmanager
    wirelesstools
    pulseaudio
    procps
    iproute2
    hyprland
  ];
  depPath = lib.makeBinPath dependencies;
in
{
  home.packages = [ pkgs.quickshell ];

  xdg.configFile."quickshell/shell.qml".source = pkgs.replaceVars ./shell.qml {
    bg = theme.background;
    fg = theme.foreground;
    accent = theme.accent;
    surface = theme.selection_background;
  };
  xdg.configFile."quickshell/scripts" = {
    source = ../eww/scripts;
    recursive = true;
  };

  home.activation.quickshellScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    chmod +x "$HOME/.config/quickshell/scripts/"* 2>/dev/null || true
  '';

  systemd.user.services.quickshell = {
    Unit = {
      Description = "Quickshell";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Environment = "PATH=${depPath}:/run/current-system/sw/bin";
      ExecStart = "${pkgs.quickshell}/bin/qs";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
