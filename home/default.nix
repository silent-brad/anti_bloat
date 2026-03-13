{ config, pkgs, lib, inputs, ... }:

{
  imports = [
    ./shell/nushell
    ./shell/starship.nix
    ./terminal/ghostty.nix
    ./editors/neovim
    ./desktop/hyprland
    ./desktop/swww
    ./desktop/waybar
    ./desktop/rofi
    ./desktop/kanshi
    ./desktop/cursor.nix
  ];

  home.username = "redironninja";
  home.homeDirectory = "/home/redironninja";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Browsers
    brave

    # Desktop apps
    krita
    obsidian
    protonmail-desktop
    bibletime
    anytype
    zathura
    libreoffice
    calibre
    thunar
    feh

    # Media
    yewtube
    mpv
    libwebp

    # Development
    gcc
    go
    nodejs
    nimble
    nimlsp
    amp-cli
    awscli2
    terraform
    awsebcli
    codecrafters-cli

    # CLI tools
    typst
    khal
    meli
    typer
    kjv
    so
    hn-text
    ddgr
    dex

    # Radicle
    radicle-node
    radicle-httpd
    radicle-explorer
  ];

  # XDG directories
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Git configuration
  programs.git = {
    enable = true;
    settings.user.name = "silent-brad"; # Set your name
    # settings.user.email = "your@email.com";  # Set your email
    settings.user.email = "bradscottwhite@gmail.com";
  };
}
