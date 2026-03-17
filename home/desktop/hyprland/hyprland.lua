local bind = hypr.binds.set

-- Programs
local terminal = "LIBGL_ALWAYS_SOFTWARE=1 ghostty"
local browser =
	"brave --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=TouchpadOverscrollHistoryNavigation"
local fileManager = "thunar"
local menu = "rofi -show drun"

-- Fullscreen
bind("CTRL", "Return", "fullscreen", "")

-- Application bindings
bind("SUPER", "Return", "exec", terminal)
bind("SUPER", "A", "exec", browser)
bind("SUPER", "K", "exec", "krita")
bind("SUPER", "O", "exec", "obsidian")
bind("SUPER", "P", "exec", "protonmail")
bind("SUPER", "R", "exec", menu)
bind("SUPER", "F", "exec", fileManager)
bind("SUPER", "B", "exec", terminal .. " -e btop")
bind("SUPER", "T", "exec", terminal .. " -e nvim tl.md")
bind("SUPER", "Z", "exec", "zathura")
bind("SUPER", "S", "exec", browser .. " --new-window --app=https://search.brave.com")
bind("SUPER", "slash", "exec", browser .. " --new-window --app=https://search.nixos.org/packages")

-- Window management
bind("SUPER", "Q", "killactive", "")
bind("SUPER", "M", "exit", "")

-- Focus with arrow keys
bind("SUPER", "left", "movefocus", "l")
bind("SUPER", "right", "movefocus", "r")
bind("SUPER", "up", "movefocus", "u")
bind("SUPER", "down", "movefocus", "d")

-- Workspaces 1-10
bind("SUPER", "1", "workspace", "1")
bind("SUPER", "2", "workspace", "2")
bind("SUPER", "3", "workspace", "3")
bind("SUPER", "4", "workspace", "4")
bind("SUPER", "5", "workspace", "5")
bind("SUPER", "6", "workspace", "6")
bind("SUPER", "7", "workspace", "7")
bind("SUPER", "8", "workspace", "8")
bind("SUPER", "9", "workspace", "9")
bind("SUPER", "0", "workspace", "10")

-- Move to workspaces
bind("SUPER SHIFT", "1", "movetoworkspace", "1")
bind("SUPER SHIFT", "2", "movetoworkspace", "2")
bind("SUPER SHIFT", "3", "movetoworkspace", "3")
bind("SUPER SHIFT", "4", "movetoworkspace", "4")
bind("SUPER SHIFT", "5", "movetoworkspace", "5")
bind("SUPER SHIFT", "6", "movetoworkspace", "6")
bind("SUPER SHIFT", "7", "movetoworkspace", "7")
bind("SUPER SHIFT", "8", "movetoworkspace", "8")
bind("SUPER SHIFT", "9", "movetoworkspace", "9")
bind("SUPER SHIFT", "0", "movetoworkspace", "10")

-- Scroll through workspaces
bind("SUPER", "mouse_down", "workspace", "e+1")
bind("SUPER", "mouse_up", "workspace", "e-1")

-- Resize
bind("SUPER", "minus", "resizeactive", "-50 0", { flags = "e" })
bind("SUPER", "equal", "resizeactive", "50 0", { flags = "e" })
bind("SUPER SHIFT", "minus", "resizeactive", "0 -50", { flags = "e" })
bind("SUPER SHIFT", "equal", "resizeactive", "0 50", { flags = "e" })

-- Color picker
bind("SUPER SHIFT", "I", "exec", "hyprpicker -a")

-- Move windows
bind("SUPER CTRL", "left", "movewindow", "l")
bind("SUPER CTRL", "right", "movewindow", "r")
bind("SUPER CTRL", "up", "movewindow", "u")
bind("SUPER CTRL", "down", "movewindow", "d")

-- Media keys (volume)
bind("", "XF86AudioRaiseVolume", "exec", "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+", { flags = "el" })
bind("", "XF86AudioLowerVolume", "exec", "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-", { flags = "el" })
bind("", "XF86AudioMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle", { flags = "el" })
bind("", "XF86AudioMicMute", "exec", "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle", { flags = "el" })

-- Brightness
bind("", "XF86MonBrightnessUp", "exec", "brightnessctl -e4 -n2 set 5%+", { flags = "el" })
bind("", "XF86MonBrightnessDown", "exec", "brightnessctl -e4 -n2 set 5%-", { flags = "el" })

-- Playerctl
bind("", "XF86AudioNext", "exec", "playerctl next", { flags = "l" })
bind("", "XF86AudioPause", "exec", "playerctl play-pause", { flags = "l" })
bind("", "XF86AudioPlay", "exec", "playerctl play-pause", { flags = "l" })
bind("", "XF86AudioPrev", "exec", "playerctl previous", { flags = "l" })
