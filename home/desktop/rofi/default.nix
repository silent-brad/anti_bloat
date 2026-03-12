{ config, pkgs, lib, ... }:

{
  programs.rofi = {
    enable = true;
    package = pkgs.rofi;
    terminal = "ghostty";
    extraConfig = {
      modi = "drun,run,window";
      show-icons = true;
    };
  };
}
