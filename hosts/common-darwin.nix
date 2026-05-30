{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  nixpkgs.config.allowUnfree = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  environment.systemPackages = with pkgs; [
    nushell
    vim
    wget
    git
    gh
    forgejo-cli
    lazygit
    btop
    fastfetch
    sqlite
    dict

    eza
    bat
    fd
    tokei
    dust

    pass
    gnupg
    pinentry-curses

    zip
    unzip

    openssl
    rsync
    pandoc

    nix-prefetch-github
    prefetch-npm-deps
  ];
}
