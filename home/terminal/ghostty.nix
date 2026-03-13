{ config, pkgs, lib, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Rose Pine";
      font-family = "FiraCode Nerd Font";
      font-size = 12;
      shell-integration = "nushell";
      command = "nu";
    };
  };
}
