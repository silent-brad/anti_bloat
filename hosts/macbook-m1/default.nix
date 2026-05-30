{
  config,
  pkgs,
  inputs,
  secrets ? { },
  ...
}:

let
  username = secrets.username or "redironninja";
in
{
  imports = [
    ../common-darwin.nix
  ];

  networking.hostName = secrets.hostname or "macbook";

  system.primaryUser = username;

  users.users.${username} = {
    home = "/Users/${username}";
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
