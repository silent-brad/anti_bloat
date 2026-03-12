local bind = hypr.binds.set

-- Programs
local terminal = "LIBGL_ALWAYS_SOFTWARE=1 ghostty"
local browser =
	"brave --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=TouchpadOverscrollHistoryNavigation"
local fileManager = "thunar"
local menu = "rofi -show drun"

-- General settings
hypr.general.setup({
	gaps_in = 3,
	gaps_out = 6,
	border_size = 2,
	col = {
		active_border = "rgba(33ccffee) rgba(00ff99ee) 45deg",
		inactive_border = "rgba(595959aa)",
	},
	resize_on_border = false,
	allow_tearing = false,
	layout = "dwindle",
})

-- Decoration
hypr.decoration.setup({
	rounding = 2,
	active_opacity = 0.8,
	inactive_opacity = 0.75,
	shadow = {
		enabled = true,
		range = 2,
		render_power = 3,
		color = "rgba(1a1a1aee)",
	},
	blur = {
		enabled = true,
		size = 3,
		passes = 1,
		vibrancy = 0.1696,
	},
})

-- Animations
hypr.animations.setup({
	enabled = true,
	bezier = {
		{ "easeOutQuint", 0.23, 1, 0.32, 1 },
		{ "easeInOutCubic", 0.65, 0.05, 0.36, 1 },
		{ "linear", 0, 0, 1, 1 },
		{ "almostLinear", 0.5, 0.5, 0.75, 1.0 },
		{ "quick", 0.15, 0, 0.1, 1 },
	},
	animation = {
		{ "global", 1, 10, "default" },
		{ "border", 1, 5.39, "easeOutQuint" },
		{ "windows", 1, 4.79, "easeOutQuint" },
		{ "windowsIn", 1, 4.1, "easeOutQuint", "popin 87%" },
		{ "windowsOut", 1, 1.49, "linear", "popin 87%" },
		{ "fadeIn", 1, 1.73, "almostLinear" },
		{ "fadeOut", 1, 1.46, "almostLinear" },
		{ "fade", 1, 3.03, "quick" },
		{ "layers", 1, 3.81, "easeOutQuint" },
		{ "layersIn", 1, 4, "easeOutQuint", "fade" },
		{ "layersOut", 1, 1.5, "linear", "fade" },
		{ "fadeLayersIn", 1, 1.79, "almostLinear" },
		{ "fadeLayersOut", 1, 1.39, "almostLinear" },
		{ "workspaces", 1, 1.94, "almostLinear", "fade" },
		{ "workspacesIn", 1, 1.21, "almostLinear", "fade" },
		{ "workspacesOut", 1, 1.94, "almostLinear", "fade" },
	},
})

-- Dwindle layout
hypr.dwindle.setup({
	pseudotile = true,
	preserve_split = true,
})

-- Master layout
hypr.master.setup({
	new_status = "master",
})

-- Misc
hypr.misc.setup({
	force_default_wallpaper = 0,
	disable_hyprland_logo = true,
	disable_splash_rendering = true,
})

-- Input
hypr.input.setup({
	kb_layout = "us",
	follow_mouse = 1,
	sensitivity = 0,
	touchpad = {
		natural_scroll = true,
	},
})

-- Environment variables
hypr.env.set("XCURSOR_SIZE", "24")
hypr.env.set("HYPRCURSOR_SIZE", "24")

-- Autostart
hypr.exec_once("hyprctl setcursor Adwaita 18")
hypr.exec_once("waybar & ~/.config/hypr/scripts/wallpaper-cycle.sh")

-- Window rules
hypr.windowrule.add("match:class .*", "opacity 0.8 0.75")
hypr.windowrule.add("match:class ^(brave)", "opacity 0.97 0.9")
hypr.windowrule.add("match:class .*", "suppress_event maximize")
hypr.layerrule.add("blur on", "match:namespace rofi")

-- Workspace rules (smart gaps)
hypr.workspace.add("w[tv1]", "gapsout:0, gapsin:0")
hypr.workspace.add("f[1]", "gapsout:0, gapsin:0")

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
bind("SUPER", "Z", "exec", "zathura")

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
