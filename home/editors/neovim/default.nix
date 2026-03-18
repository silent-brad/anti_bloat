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

  # Generate secrets.lua at activation from secrets.nix (bypasses Nix store caching)
  home.activation.nvimSecrets = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    secrets_nix="$HOME/anti_bloat/secrets/secrets.nix"
    out="$HOME/.config/nvim/lua/secrets.lua"
    if [ -f "$secrets_nix" ]; then
      key=$(${pkgs.gnugrep}/bin/grep 'openrouter_api_key' "$secrets_nix" | ${pkgs.gnused}/bin/sed 's/.*= *"\(.*\)".*/\1/')
    else
      key="YOUR_KEY_HERE"
    fi
    mkdir -p "$(dirname "$out")"
    cat > "$out" << EOF
    return {
      openrouter_api_key = "$key",
    }
    EOF
  '';
}
