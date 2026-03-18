{
  config,
  pkgs,
  lib,
  inputs,
  theme,
  ...
}:

{
  imports = [ inputs.pinnacle.hmModules.default ];

  wayland.windowManager.pinnacle = {
    enable = true;
    package = inputs.pinnacle.packages.${pkgs.system}.default;
    clientPackage = inputs.pinnacle.packages.${pkgs.system}.default;
    config.execCmd = [
      "lua"
      "pinnacle_config.lua"
    ];
    systemd = {
      enable = true;
      useService = true;
    };
  };

  xdg.configFile."pinnacle/pinnacle_config.lua".text =
    builtins.replaceStrings
      [ ''local nix_theme = require("nix-theme")'' ]
      [ ''local nix_theme = { accent = "${theme.accent}", bg = "${theme.background}", surface = "${theme.selection_background}" }'' ]
      (builtins.readFile ./pinnacle_config.lua);

  # Symlink the Snowcap Lua module into the config dir so require("snowcap") resolves
  xdg.configFile."pinnacle/snowcap.lua".source = "${inputs.pinnacle}/snowcap/api/lua/snowcap.lua";
  xdg.configFile."pinnacle/snowcap".source = "${inputs.pinnacle}/snowcap/api/lua/snowcap";

  home.activation.reloadPinnacle = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${inputs.pinnacle.packages.${pkgs.system}.default}/bin/pinnacle client -e 'require("pinnacle").reload_config()' 2>/dev/null || true
  '';
}
