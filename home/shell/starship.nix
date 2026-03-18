{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

let
  tomlSettings = builtins.fromTOML (builtins.readFile ./starship.toml);
in
{
  programs.starship = {
    enable = true;
    enableNushellIntegration = true;
    settings = tomlSettings // {
      palette = theme.name;
      palettes = {
        ${theme.name} = {
          overlay = theme.overlay;
          error = theme.error;
          warning = theme.warning;
          primary = theme.primary;
          info = theme.info;
          success = theme.success;
          secondary = theme.secondary;
        };
      };
    };
  };
}
