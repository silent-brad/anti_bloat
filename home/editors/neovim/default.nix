{
  config,
  pkgs,
  lib,
  secrets ? { },
  theme,
  ...
}:

let
  nimfmt = pkgs.stdenv.mkDerivation {
    pname = "nimfmt";
    version = "0.2.0";
    src = pkgs.fetchFromGitHub {
      owner = "FedericoCeratto";
      repo = "nimfmt";
      rev = "0.2.0";
      hash = "sha256-AFh5ZQcusdAR7VCd/Uj3QB0eUiFNI8tVMkAyxUDGePU=";
    };
    nativeBuildInputs = [ pkgs.nim ];
    buildPhase = ''
      export HOME=$TMPDIR
      nim c -d:nimpretty -d:release --hints:off \
        -p:${pkgs.nim.passthru.nim}/nim nimfmt.nim
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp nimfmt $out/bin/
    '';
  };

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
        java
        pug
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
    nodePackages.prettier
    tailwindcss-language-server
    angular-language-server
    ocamlPackages.ocaml-lsp
    ocamlPackages.reason
    ocamlformat
    nushellPlugins.formats
    nim
    nimble
    nimlangserver
    nimfmt
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
    jdt-language-server
    google-java-format
    checkstyle
    jinja-lsp
    vimPlugins.parinfer-rust # For Lisp
    luarocks
    lua
    python3
    tdf
    poppler-utils
    chafa
    curl
    jq
    gcc
    pkg-config
  ];

  xdg.configFile."nvim/init.lua".source = ./lua/init.lua;

  xdg.configFile."nvim/lua/nix-treesitter-parsers.lua".text = ''
    return "${treesitterParsers}"
  '';
  xdg.configFile."nvim/lua/nix-theme.lua".text = ''
    return {
      plugin = "${theme.neovim.plugin}",
      colorscheme = "${theme.neovim.colorscheme}",
      variant = "${theme.neovim.variant}",
    }
  '';
  xdg.configFile."nvim/lua/nim-snake-case.lua".source = ./lua/nim-snake-case.lua;
  xdg.configFile."nvim/lua/lazy-bootstrap.lua".source = ./lua/lazy-bootstrap.lua;
  xdg.configFile."nvim/lua/plugins/init.lua".source = ./lua/plugins/init.lua;
  xdg.configFile."nvim/lua/plugins/lsp.lua".source = ./lua/plugins/lsp.lua;
  xdg.configFile."nvim/lua/plugins/fff.lua".source = ./lua/plugins/fff.lua;
  xdg.configFile."nvim/lua/plugins/99.lua".source = ./lua/plugins/99.lua;
  xdg.configFile."nvim/lua/typst-preview.lua".source = ./lua/typst-preview.lua;
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
      cd "$fff_dir" && ${pkgs.cargo}/bin/cargo build --release -p fff-nvim 2>&1 || true
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
