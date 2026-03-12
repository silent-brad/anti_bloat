{ config, pkgs, lib, ... }:

{
  boot.kernelModules = [ "e1000e" ];

  services.udev.extraRules = ''
    # USB hub support for ThinkPad UltraBase
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="17ef", MODE="0666"
  '';
}
