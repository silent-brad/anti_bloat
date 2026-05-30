# Nushell Environment Config

# PATH additions
$env.PATH = ($env.PATH | split row (char esep) | prepend [
  $"($env.HOME)/.local/bin"
  $"($env.HOME)/.cargo/bin"
  $"($env.HOME)/.npm-global/bin"
])

# Editor
$env.EDITOR = "hx"
$env.VISUAL = "hx"

# XDG directories
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.XDG_DATA_HOME = $"($env.HOME)/.local/share"
$env.XDG_CACHE_HOME = $"($env.HOME)/.cache"
