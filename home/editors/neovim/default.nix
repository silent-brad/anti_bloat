{ config, pkgs, lib, secrets ? {}, ... }:

{
  programs.neovim = {
    enable = true;
    defaultEditor = true;
    viAlias = true;
    vimAlias = true;
  };

  home.packages = with pkgs; [
    rust-analyzer
    gopls
    vtsls
    tailwindcss-language-server
    angular-language-server
    nimlangserver
    lua-language-server
    luaformatter
    stylua
    luau-lsp
    selene
    tinymist
    typstyle
    semgrep
    stylelint
    stylelint-lsp
    vimPlugins.parinfer-rust # For Lisp
    luarocks
    python3
    curl
    jq
  ];

  xdg.configFile."nvim/init.lua".source = ./lua/init.lua;
  xdg.configFile."nvim/lua/lazy-bootstrap.lua".source = ./lua/lazy-bootstrap.lua;
  xdg.configFile."nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
  xdg.configFile."nvim/lua/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
  xdg.configFile."nvim/lua/plugins/99.lua".source = ./lua/plugins/99.lua;
  xdg.configFile."nvim/lua/openrouter-provider.lua".source = ./lua/openrouter-provider.lua;

  # Generate secrets.lua from the Nix secrets attrset
  xdg.configFile."nvim/lua/secrets.lua".text = ''
    return {
      openrouter_api_key = "${secrets.openrouter_api_key or "YOUR_KEY_HERE"}",
    }
  '';
}
