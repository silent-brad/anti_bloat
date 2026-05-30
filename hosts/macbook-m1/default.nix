{
  config,
  pkgs,
  inputs,
  secrets ? { },
  ...
}:

{
  imports = [
    ../common-darwin.nix
  ];

  networking.hostName = secrets.hostname or "macbook";

  users.users.redironninja = {
    home = "/Users/redironninja";
    shell = pkgs.nushell;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.fira-code
    nerd-fonts.meslo-lg
  ];

  # Enable Touch ID for sudo
  security.pam.services.sudo_local.touchIdAuth = true;

  system.stateVersion = 6;
}
