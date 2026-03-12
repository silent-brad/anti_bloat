{ config, pkgs, lib, ... }:

{
  # Kanshi configuration is handled by home-manager
  # This module ensures the package is available system-wide if needed
  environment.systemPackages = with pkgs; [ kanshi ];
}
