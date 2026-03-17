{ config, pkgs, inputs, ... }:

{
  imports = [ inputs.pinnacle.hmModules.default ];

  wayland.windowManager.pinnacle = {
    enable = true;
    package = inputs.pinnacle.packages.${pkgs.system}.default;
    clientPackage = inputs.pinnacle.packages.${pkgs.system}.default;
    config.execCmd = [ "lua" "pinnacle_config.lua" ];
    systemd = {
      enable = true;
      useService = true;
    };
  };

  xdg.configFile."pinnacle/pinnacle_config.lua".source = ./pinnacle_config.lua;

  # Symlink the Snowcap Lua module into the config dir so require("snowcap") resolves
  xdg.configFile."pinnacle/snowcap.lua".source =
    "${inputs.pinnacle}/snowcap/api/lua/snowcap.lua";
  xdg.configFile."pinnacle/snowcap".source =
    "${inputs.pinnacle}/snowcap/api/lua/snowcap";
}
