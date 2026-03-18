{ config, pkgs, lib, ... }:

{
  services.printing = {
    enable = true;
    drivers = [ pkgs.cnijfilter2 pkgs.gutenprint ];
    webInterface = true;
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    openFirewall = true;
  };
}
