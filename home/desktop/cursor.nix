{
  config,
  pkgs,
  lib,
  ...
}:

{
  home.pointerCursor = {
    name = "Adwaita";
    size = 18;
    package = pkgs.adwaita-icon-theme;
    gtk.enable = true;
    x11.enable = true;
  };
}
