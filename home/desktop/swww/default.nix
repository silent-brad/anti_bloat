{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

{
  home.packages = [ pkgs.awww ];

  home.file.".local/bin/wallpaper-cycle.nu" = {
    source = pkgs.replaceVars ./wallpaper-cycle.nu {
      themeName = theme.name;
    };
    executable = true;
  };

  systemd.user.services.wallpaper-cycle = {
    Unit = {
      Description = "Wallpaper cycling service using swww";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };
    Service = {
      Type = "simple";
      ExecStart = "${config.home.homeDirectory}/.local/bin/wallpaper-cycle.nu";
      Restart = "on-failure";
      RestartSec = 5;
    };
    Install = {
      WantedBy = [ "graphical-session.target" ];
    };
  };
}
