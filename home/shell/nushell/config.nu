# Nushell Config File

$env.config = {
  show_banner: false

  edit_mode: nvim

  keybindings: [
    {
      name: completion_menu
      modifier: control
      keycode: char_n
      mode: nvim
      event: { send: menu name: completion_menu }
    }
    {
      name: completion_previous
      modifier: control
      keycode: char_p
      mode: nvim
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: nvim
      event: { send: menu name: history_menu }
    }
    {
      name: clear_screen
      modifier: control
      keycode: char_l
      mode: nvim
      event: { send: clearscreen }
    }
  ]

  completions: {
    case_sensitive: false
    quick: true
    partial: true
    algorithm: "fuzzy"
  }

  history: {
    max_size: 10000
    sync_on_enter: true
    file_format: "sqlite"
  }

  cursor_shape: {
    nvim: line
    vi_insert: line
    vi_normal: block
  }
}
