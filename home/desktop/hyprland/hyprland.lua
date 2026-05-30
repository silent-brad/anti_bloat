-- Anti_Bloat Hyprland config

local theme = require("theme")

local brave =
	"brave --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=TouchpadOverscrollHistoryNavigation"

---- MONITORS ----
hl.monitor({
	output = "",
	mode = "preferred",
	position = "auto",
	scale = "auto",
})

---- ENVIRONMENT ----
hl.env("XCURSOR_SIZE", "24")

---- INPUT ----
hl.config({
	input = {
		kb_layout = "us",
		follow_mouse = 1,
		touchpad = {
			natural_scroll = true,
		},
	},
})

---- LOOK AND FEEL ----
hl.config({
	general = {
		gaps_out = 6,
		gaps_in = 3,
		border_size = 2,
		col = {
			active_border = theme.accent,
			inactive_border = theme.inactive,
		},
		layout = "dwindle",
	},

	decoration = {
		rounding = 6,
		active_opacity = 0.85,
		inactive_opacity = 0.8,
		shadow = {
			enabled = true,
			range = 12,
			render_power = 3,
			color = 0x44000000,
		},
		blur = {
			enabled = true,
			size = 6,
			passes = 2,
			ignore_opacity = true,
		},
	},

	animations = {
		enabled = true,
	},

	dwindle = {
		preserve_split = true,
	},

	misc = {
		disable_hyprland_logo = true,
		disable_splash_rendering = true,
	},
})

---- CURVES ----
hl.curve("quick", { type = "bezier", points = { { 0.15, 0 }, { 0.1, 1 } } })
hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("almostLinear", { type = "bezier", points = { { 0.5, 0.5 }, { 0.75, 1 } } })

---- ANIMATIONS ----
hl.animation({ leaf = "windows", enabled = true, speed = 2, bezier = "quick" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 2, bezier = "linear", style = "popin 80%" })
hl.animation({ leaf = "fade", enabled = true, speed = 2, bezier = "almostLinear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 2, bezier = "almostLinear" })

---- WINDOW RULES ----
hl.window_rule({ match = { class = ".*" }, border_size = 0 })
hl.window_rule({ match = { class = ".*" }, no_shadow = true })
hl.window_rule({ match = { class = ".*" }, no_blur = true })

---- AUTOSTART ----
hl.on("hyprland.start", function()
	hl.exec_cmd("awww-daemon")
	hl.exec_cmd("sleep 1 && ~/.local/bin/wallpaper-cycle.nu")
end)

---- KEYBINDINGS ----
local mainMod = "SUPER"

-- App launches
hl.bind(mainMod .. " + Return", hl.dsp.exec_cmd("ghostty"))
hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(brave))
hl.bind(mainMod .. " + K", hl.dsp.exec_cmd("krita"))
hl.bind(mainMod .. " + O", hl.dsp.exec_cmd("obsidian"))
hl.bind(mainMod .. " + P", hl.dsp.exec_cmd("protonmail"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("rofi -show drun"))
hl.bind(mainMod .. " + F", hl.dsp.exec_cmd("thunar"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd("ghostty -e btop"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("ghostty -e nvim tl.md"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd("zathura"))
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd(brave .. " --new-window --app=https://search.brave.com"))
hl.bind(mainMod .. " + slash", hl.dsp.exec_cmd(brave .. " --new-window --app=https://search.nixos.org/packages"))

-- Window management
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + space", hl.dsp.layout("togglesplit"))
hl.bind("CTRL + Return", hl.dsp.window.fullscreen({ action = "toggle" }))

-- Screenshot & recording
hl.bind("Print", hl.dsp.exec_cmd('grim -g "$(slurp)" - | satty -f -'))
hl.bind(
	mainMod .. " + Print",
	hl.dsp.exec_cmd("mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png")
)
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd(
		'if pgrep -x wf-recorder > /dev/null; then pkill -INT wf-recorder; else mkdir -p ~/Videos/Recordings && wf-recorder -g "$(slurp)" -f ~/Videos/Recordings/$(date +%Y%m%d_%H%M%S).mp4; fi'
	)
)

-- Focus
hl.bind(mainMod .. " + left", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + right", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + up", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + down", hl.dsp.focus({ direction = "down" }))

-- Move windows (swap)
hl.bind(mainMod .. " + CTRL + left", hl.dsp.window.swap({ direction = "left" }))
hl.bind(mainMod .. " + CTRL + right", hl.dsp.window.swap({ direction = "right" }))
hl.bind(mainMod .. " + CTRL + up", hl.dsp.window.swap({ direction = "up" }))
hl.bind(mainMod .. " + CTRL + down", hl.dsp.window.swap({ direction = "down" }))

-- Tile resizing
hl.bind(mainMod .. " + minus", hl.dsp.window.resize({ x = 0, y = -50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + equal", hl.dsp.window.resize({ x = 0, y = 50, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.window.resize({ x = -50, y = 0, relative = true }), { repeating = true })
hl.bind(mainMod .. " + SHIFT + equal", hl.dsp.window.resize({ x = 50, y = 0, relative = true }), { repeating = true })

-- Workspaces 1-10
for i = 1, 10 do
	local key = i % 10
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Media keys
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })

-- Repeatable: volume & brightness
hl.bind(
	"XF86AudioRaiseVolume",
	hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"),
	{ locked = true, repeating = true }
)
hl.bind(
	"XF86AudioLowerVolume",
	hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"),
	{ locked = true, repeating = true }
)
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })

-- Mouse bindings
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })
