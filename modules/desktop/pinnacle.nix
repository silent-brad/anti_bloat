{ config, pkgs, lib, inputs, ... }:

{
  imports = [ inputs.pinnacle.nixosModules.default ];

  nixpkgs.overlays = [ inputs.pinnacle.overlays.default ];

  programs.pinnacle = {
    enable = true;
    xdg-portals.enable = true;
  };

  programs.command-not-found.enable = true;
}
