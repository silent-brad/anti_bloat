{ config, pkgs, lib, ... }:

{
  programs.hyprland.enable = true;
  programs.command-not-found.enable = true;

  environment.systemPackages = with pkgs; [ hyprland hyprpicker ];
}
