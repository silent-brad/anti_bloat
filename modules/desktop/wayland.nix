{ config, pkgs, lib, ... }:

{
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
    # Point libdecor to a nonexistent dir so it loads no CSD decoration plugins (no title bars)
    LIBDECOR_PLUGIN_DIR = "/dev/null";
  };

  environment.systemPackages = with pkgs; [
    wayland
    xdg-utils
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    wl-clipboard
  ];
}
