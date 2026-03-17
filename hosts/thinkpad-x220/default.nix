{ config, pkgs, inputs, secrets ? {}, ... }:

{
  imports = [
    ./hardware.nix
    ../common.nix
    ../../modules/desktop/pinnacle.nix
    ../../modules/desktop/wayland.nix
    ../../modules/services/audio.nix
    ../../modules/services/printing.nix
    ../../modules/services/devdocs.nix
    ../../modules/virtualisation.nix
    ../../hardware/profiles/thinkpad-x220.nix
    ../../hardware/profiles/intel-gpu.nix
    ../../hardware/peripherals/canon-g6000.nix
    ../../hardware/peripherals/ultrabase.nix
  ];

  networking.hostName = secrets.hostname or "nixos";

  boot.loader.grub = {
    enable = true;
    efiSupport = false;
    device = "/dev/sda";
  };

  services.xserver.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.wayland = true;

  users.users.redironninja = {
    isNormalUser = true;
    extraGroups = [ "wheel" "docker" "libvirtd" "dialout" "plugdev" ];
    packages = with pkgs; [ tree ];
  };

  users.defaultUserShell = pkgs.nushell;

  fonts.packages = with pkgs; [
    garamond-libre
    junicode
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
  ];

  programs.nix-ld.enable = true;

  services.flatpak.enable = true;

  services.dictd = {
    enable = true;
    DBs = with pkgs.dictdDBs; [ wiktionary ];
  };

  networking.firewall = {
    allowedTCPPorts = [ 631 ];
    allowedUDPPorts = [ 631 ];
  };

  system.stateVersion = "25.05";
}
