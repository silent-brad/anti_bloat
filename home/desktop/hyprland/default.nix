{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false; # We use GDM, not systemd activation
    settings = {
      # Minimal settings - main config is in hyprland.lua via Hyprlua plugin
      # This satisfies home-manager's requirement for some config
      "$mod" = "SUPER";
    };
    extraConfig = ''
      # Load Hyprlua plugin (update path after building)
      # plugin = /path/to/libhyprlua.so
    '';
  };

  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;
}
