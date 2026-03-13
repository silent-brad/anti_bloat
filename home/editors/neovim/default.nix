{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  xdg.configFile."nvim/init.lua".source = ./lua/init.lua;
  xdg.configFile."nvim/lua/lazy-bootstrap.lua".source = ./lua/lazy-bootstrap.lua;
  xdg.configFile."nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
  xdg.configFile."nvim/lua/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
}
