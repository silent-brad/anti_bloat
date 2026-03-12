{ config, pkgs, lib, ... }:

{
  boot.kernelModules = [ "thinkpad_acpi" "kvm-intel" ];

  hardware.enableAllFirmware = true;

  services.libinput = {
    enable = true;
    touchpad = { naturalScrolling = true; };
  };
}
