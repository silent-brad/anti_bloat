{ config, pkgs, lib, ... }:

{
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    QT_QPA_PLATFORM = "wayland";
    GDK_BACKEND = "wayland";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    XDG_SESSION_TYPE = "wayland";
  };

  environment.systemPackages = with pkgs; [
    wayland
    xdg-utils
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    wl-clipboard
  ];
}
