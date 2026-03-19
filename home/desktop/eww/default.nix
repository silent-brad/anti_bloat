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
    pinnacle
  ];
  depPath = lib.makeBinPath dependencies;
in
{
  home.packages = [ pkgs.eww ];

  xdg.configFile."eww/eww.yuck".source = ./eww.yuck;
  xdg.configFile."eww/eww.scss".text = ''
    $bg:      ${theme.background};
    $fg:      ${theme.foreground};
    $accent:  ${theme.accent};
    $surface: ${theme.selection_background};
  ''
  + builtins.readFile ./eww.scss;
  xdg.configFile."eww/scripts" = {
    source = ./scripts;
    recursive = true;
  };

  # Wrap scripts with dependency PATH
  home.activation.ewwScripts = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    chmod +x "$HOME/.config/eww/scripts/"* 2>/dev/null || true
  '';

  systemd.user.services.eww = {
    Unit = {
      Description = "EWW daemon";
      PartOf = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Service = {
      Environment = "PATH=${depPath}:/run/current-system/sw/bin";
      ExecStart = "${pkgs.eww}/bin/eww daemon --no-daemonize";
      ExecStartPost = "${pkgs.eww}/bin/eww open bar";
      Restart = "on-failure";
      RestartSec = 3;
    };
    Install.WantedBy = [ "graphical-session.target" ];
  };
}
