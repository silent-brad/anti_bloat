{
  config,
  lib,
  pkgs,
  ...
}:

{
  services.kanshi = {
    enable = true;
    systemdTarget = "graphical-session.target";

    settings = [
      {
        profile.name = "undocked";
        profile.outputs = [
          {
            criteria = "LVDS-1";
            mode = "1366x768@60Hz";
          }
        ];
      }
      {
        profile.name = "docked";
        profile.outputs = [
          {
            criteria = "LVDS-1";
            status = "disable";
          }
          {
            criteria = "HDMI-A-2";
            mode = "1920x1080";
          }
          {
            criteria = "VGA-1";
            mode = "1920x1080";
            transform = "90";
          }
        ];
      }
    ];
  };
}
