{
  config,
  pkgs,
  lib,
  inputs,
  secrets ? { },
  theme,
  ...
}:

{
  imports = [
    ./shell/nushell
    ./shell/starship.nix
    ./terminal/ghostty.nix
    ./terminal/btop.nix
    ./editors/neovim
    ./desktop/pinnacle
    ./desktop/swww
    ./desktop/rofi
    ./desktop/eww
    ./desktop/cursor.nix
  ];

  home.username = "redironninja";
  home.homeDirectory = "/home/redironninja";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs; [
    # Desktop apps
    brave
    krita
    obsidian
    protonmail-desktop
    bibletime
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
    amp-cli
    awscli2
    terraform
    awsebcli
    codecrafters-cli
    cloudflared

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

  # Hide GTK3/4 CSD title bars (headerbar) for tiling WM
  gtk = {
    enable = true;
    gtk3.extraCss = ''
      headerbar, .titlebar { min-height: 0; padding: 0; margin: 0; background: ${theme.bg}; }
      headerbar, .titlebar, .default-decoration { background: ${theme.bg}; box-shadow: none; border: none; min-height: 0; padding: 0; margin: 0; }
      window.background headerbar:first-child,
      window.background .titlebar:first-child { min-height: 0; font-size: 0; }
      .titlebar .title { font-size: 0; color: ${theme.fg}; }
      .titlebar button { min-height: 0; min-width: 0; padding: 0; margin: 0; }
    '';
  };

  # XDG directories
  xdg.enable = true;
  xdg.userDirs = {
    enable = true;
    createDirectories = true;
  };

  # Git configuration (update values in secrets/secrets.nix)
  programs.git = {
    enable = true;
    settings.user.name = secrets.git_username or "silent-brad";
    settings.user.email = secrets.git_email or "bradscottwhite@gmail.com";
  };
}
