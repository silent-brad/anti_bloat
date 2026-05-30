{
  config,
  pkgs,
  lib,
  ...
}:

{
  # Set npm global prefix to a writable directory
  home.file.".npmrc".text = ''
    prefix=''${HOME}/.npm-global
  '';

  # Ensure ~/.npm-global/bin is in PATH
  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  # Install pi coding agent via npm
  home.activation.installPi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    export PATH="${pkgs.nodejs}/bin:$PATH"
    export npm_config_prefix="$HOME/.npm-global"
    mkdir -p "$HOME/.npm-global"
    if [ ! -x "$HOME/.npm-global/bin/pi" ]; then
      npm install -g @mariozechner/pi-coding-agent 2>&1 || true
    fi
  '';

  # Global Pi settings (~/.pi/agent/settings.json)
  home.file.".pi/agent/settings.json".text = builtins.toJSON {
    enabledModels = [
      "moonshotai/kimi-k2.6"
      "claude-*"
      "gemini-2*"
    ];
    enableSkillCommands = true;
    compaction = {
      enabled = true;
      reserveTokens = 16384;
    };
  };

  # Global AGENTS.md (~/.pi/agent/AGENTS.md)
  home.file.".pi/agent/AGENTS.md".text = ''
    # Global Pi Rules

    ## Conventions
    - Follow existing code style and conventions in every project.
    - Prefer editing existing files over creating new ones.
    - Make the smallest reasonable diff. Do not rewrite whole files to change a few lines.
    - Do not add comments unless the code is complex and requires context.
    - Do not add features, refactor code, or make improvements beyond what was asked.

    ## NixOS
    - This system runs NixOS (unstable). Use Nix idioms and conventions.
    - The shell is Nushell (`nu`), not bash. Write shell examples accordingly.
    - The editor is Neovim. The terminal is Ghostty. The WM is Hyprland (Wayland).

    ## Safety
    - Never commit or push without being asked.
    - Never expose secrets or API keys in code or output.
    - Do not modify files you were not asked to change.
  '';
}
