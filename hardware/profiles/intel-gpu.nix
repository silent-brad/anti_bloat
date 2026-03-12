{ config, pkgs, lib, ... }:

{
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
    extraPackages = with pkgs; [
      mesa
      libGL
      intel-media-driver
      intel-vaapi-driver
    ];
  };

  services.xserver.videoDrivers = [ "intel" ];
}
