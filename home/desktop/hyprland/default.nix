{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

let
  accentRgb = "rgb(${builtins.substring 1 6 theme.accent})";
  inactiveRgb = "rgb(${builtins.substring 1 6 theme.selection_background})";
in
{
  wayland.windowManager.hyprland = {
    enable = true;
    # Use the package from the NixOS module (Hyprland flake)
    package = null;
    portalPackage = null;
    # Config is managed via hyprland.lua, not the HM module
    systemd.enable = false;
    settings = { };
    extraConfig = "";
  };

  xdg.configFile."hypr/hyprland.lua".source = ./hyprland.lua;

  # Nix-generated theme values consumed by hyprland.lua via require("theme")
  xdg.configFile."hypr/theme.lua".text = ''
    return {
      accent = "${accentRgb}",
      inactive = "${inactiveRgb}",
    }
  '';
}
