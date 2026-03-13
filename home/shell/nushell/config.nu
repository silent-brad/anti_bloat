# Nushell Config File

$env.config = {
  show_banner: false

  edit_mode: vi

  keybindings: [
    {
      name: completion_menu
      modifier: control
      keycode: char_n
      mode: vi_normal
      event: { send: menu name: completion_menu }
    }
    {
      name: completion_previous
      modifier: control
      keycode: char_p
      mode: vi_normal
      event: { send: menuprevious }
    }
    {
      name: history_menu
      modifier: control
      keycode: char_r
      mode: vi_normal
      event: { send: menu name: history_menu }
    }
    {
      name: clear_screen
      modifier: control
      keycode: char_l
      mode: vi_normal
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
    vi_normal: block
    vi_insert: line
  }
}
