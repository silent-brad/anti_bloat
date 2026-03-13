{ config, pkgs, lib, ... }:

{
  home.packages = [ pkgs.swww ];

  home.file.".local/bin/wallpaper-cycle.nu" = {
    source = ./wallpaper-cycle.nu;
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
    Install = { WantedBy = [ "graphical-session.target" ]; };
  };
}
