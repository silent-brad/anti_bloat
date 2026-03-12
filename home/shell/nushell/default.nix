{ config, pkgs, lib, ... }:

{
  programs.nushell = {
    enable = true;

    configFile.source = ./config.nu;
    envFile.source = ./env.nu;

    shellAliases = {
      ls = "eza";
      ll = "eza -l";
      la = "eza -la";
      lt = "eza --tree";
      cat = "bat";
      find = "fd";
      grep = "rg";
      top = "btm";
      du = "dust";
      df = "duf";
      ps = "procs";
      rb = "sudo nixos-rebuild switch";
    };
  };
}
