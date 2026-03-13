{ config, pkgs, ... }:

{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  time.timeZone = "America/New_York";

  i18n.defaultLocale = "en_US.UTF-8";

  networking.networkmanager.enable = true;

  nixpkgs.config.allowUnfree = true;

  security.rtkit.enable = true;

  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  services.openssh.enable = true;

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
    acpi
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
    inotify-tools
    rsync
    pandoc

    nix-prefetch-github
    prefetch-npm-deps
  ];
}
