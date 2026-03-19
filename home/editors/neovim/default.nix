{
  config,
  pkgs,
  lib,
  secrets ? { },
  theme,
  ...
}:

let
  treesitterParsers = pkgs.symlinkJoin {
    name = "nvim-treesitter-parsers";
    paths =
      (with pkgs.vimPlugins.nvim-treesitter.grammarPlugins; [
        lua
        vim
        vimdoc
        nix
        bash
        nu
        markdown
        markdown_inline
        rust
        go
        ocaml
        html
        css
        javascript
        typescript
        jinja
        toml
        json
        yaml
        nim
        typst
      ])
      ++ (with pkgs.vimPlugins.nvim-treesitter.queries; [
        nu
      ]);
  };
in
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
    nodejs
    tailwindcss-language-server
    angular-language-server
    ocamlPackages.ocaml-lsp
    ocamlformat
    nushellPlugins.formats
    nimlangserver
    lua-language-server
    luaformatter
    nixfmt
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
    gcc
    pkg-config
  ];

  xdg.configFile."nvim/init.lua".source = ./lua/init.lua;

  xdg.configFile."nvim/lua/nix-treesitter-parsers.lua".text = ''
    vim.opt.runtimepath:prepend("${treesitterParsers}")
  '';
  xdg.configFile."nvim/lua/nix-theme.lua".text = ''
    return {
      plugin = "${theme.neovim.plugin}",
      colorscheme = "${theme.neovim.colorscheme}",
      variant = "${theme.neovim.variant}",
    }
  '';
  xdg.configFile."nvim/lua/lazy-bootstrap.lua".source = ./lua/lazy-bootstrap.lua;
  xdg.configFile."nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
  xdg.configFile."nvim/lua/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
  xdg.configFile."nvim/lua/plugins/fff.lua".source = ./lua/plugins/fff.lua;
  xdg.configFile."nvim/lua/plugins/99.lua".source = ./lua/plugins/99.lua;
  xdg.configFile."nvim/lua/openrouter-provider.lua".source = ./lua/openrouter-provider.lua;

  # Clone (if needed) and build fff.nvim rust binary
  home.activation.fffNvimBuild = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    fff_dir="$HOME/.local/share/nvim/lazy/fff.nvim"
    if [ ! -d "$fff_dir" ]; then
      echo "Cloning fff.nvim..."
      ${pkgs.git}/bin/git clone --filter=blob:none https://github.com/dmtrKovalenko/fff.nvim.git "$fff_dir"
    fi
    target="$fff_dir/target/release"
    if [ ! -f "$target/libfff_nvim.so" ]; then
      echo "Building fff.nvim rust backend..."
      cd "$fff_dir" && ${pkgs.nix}/bin/nix run "path:.#release" --extra-experimental-features "nix-command flakes" 2>&1 || true
    fi
  '';

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
