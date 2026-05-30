{
  config,
  pkgs,
  lib,
  inputs,
  secrets ? { },
  theme,
  isLinux ? true,
  isDarwin ? false,
  ...
}:

{
  imports =
    [
      ./shell/nushell
      ./shell/starship.nix
      ./terminal/btop.nix
      ./editors/neovim
      ./editors/pi.nix
    ]
    ++ lib.optionals isLinux [
      ./terminal/ghostty.nix
      ./desktop/hyprland
      ./desktop/swww
      ./desktop/rofi
      ./desktop/eww
      ./desktop/cursor.nix
    ];

  home.username = "redironninja";
  home.homeDirectory =
    if isDarwin then "/Users/redironninja" else "/home/redironninja";

  home.stateVersion = "25.05";

  programs.home-manager.enable = true;

  home.packages = with pkgs;
    [
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
      ddgr
      dex

      # Radicle
      radicle-node
      radicle-httpd
      radicle-explorer
    ]
    ++ lib.optionals isLinux [
      # Desktop apps (Linux / Wayland)
      brave
      inputs.thorium.packages.x86_64-linux.thorium-avx
      krita
      obsidian
      protonmail-desktop
      bibletime
      zathura
      libreoffice
      calibre
      thunar
      feh

      # Screenshot & Recording (Wayland)
      grim
      slurp
      satty
      wf-recorder
    ];

  # Hide GTK3/4 CSD title bars (headerbar) for tiling WM
  gtk = lib.mkIf isLinux {
    enable = true;
    gtk3.extraCss = ''
      headerbar, .titlebar { min-height: 0; padding: 0; margin: 0; background: ${theme.background}; }
      headerbar, .titlebar, .default-decoration { background: ${theme.background}; box-shadow: none; border: none; min-height: 0; padding: 0; margin: 0; }
      window.background headerbar:first-child,
      window.background .titlebar:first-child { min-height: 0; font-size: 0; }
      .titlebar .title { font-size: 0; color: ${theme.foreground}; }
      .titlebar button { min-height: 0; min-width: 0; padding: 0; margin: 0; }
    '';
  };

  # XDG directories
  xdg.enable = true;
  xdg.userDirs = lib.mkIf isLinux {
    enable = true;
    createDirectories = true;
    setSessionVariables = false;
  };

  # Git configuration (update values in secrets/secrets.nix)
  programs.git = {
    enable = true;
    settings.user.name = secrets.git_username or "silent-brad";
    settings.user.email = secrets.git_email or "bradscottwhite@gmail.com";
  };
}
