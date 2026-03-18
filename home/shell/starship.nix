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
          overlay = theme.color0;
          error = theme.color1;
          warning = theme.color3;
          primary = theme.color1;
          info = theme.color4;
          success = theme.color6;
          secondary = theme.color5;
        };
      };
    };
  };
}
