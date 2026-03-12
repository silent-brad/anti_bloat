{ config, pkgs, lib, ... }:

{
  virtualisation.docker.enable = true;
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;
  virtualisation.kvmgt.enable = true;

  programs.virt-manager.enable = true;
}
