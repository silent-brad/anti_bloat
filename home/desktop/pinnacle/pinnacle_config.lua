local Pinnacle = require("pinnacle")
local Input = require("pinnacle.input")
local Libinput = require("pinnacle.input.libinput")
local Process = require("pinnacle.process")
local Output = require("pinnacle.output")
local Tag = require("pinnacle.tag")
local Window = require("pinnacle.window")
local Layout = require("pinnacle.layout")
local Snowcap = require("pinnacle.snowcap")

Pinnacle.setup(function()
  local key = Input.key

  -- Programs
  local terminal = "ghostty"
  local browser =
    "brave --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=TouchpadOverscrollHistoryNavigation"
  local fileManager = "thunar"
  local menu = "rofi -show drun"

  --------------------
  -- Input
  --------------------
  Input.set_xkb_config({ layout = "us" })
  Input.set_xcursor_theme("Adwaita")
  Input.set_xcursor_size(24)

  Libinput.for_each_device(function(device)
    if device:device_type() == "touchpad" then
      device:set_natural_scroll(true)
    end
  end)

  --------------------
  -- Tags (workspaces)
  --------------------
  local tag_names = { "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" }

  Output.for_each_output(function(output)
    local tags = Tag.add(output, tag_names)
    tags[1]:set_active(true)
  end)

  --------------------
  -- Layout (dwindle first, matching Hyprland)
  --------------------
  local layout_cycler = Layout.builtin.cycle({
    Layout.builtin.dwindle({ outer_gaps = 6, inner_gaps = 3 }),
    Layout.builtin.master_stack({ outer_gaps = 6, inner_gaps = 3 }),
    Layout.builtin.spiral({ outer_gaps = 6, inner_gaps = 3 }),
    Layout.builtin.fair({ outer_gaps = 6, inner_gaps = 3 }),
    Layout.builtin.floating(),
  })

  local layout_requester = Layout.manage(function(args)
    local tag = args.tags[1]
    if not tag then
      return { root_node = {}, tree_id = 0 }
    end
    layout_cycler.current_tag = tag
    return {
      root_node = layout_cycler:layout(args.window_count),
      tree_id = layout_cycler:current_tree_id(),
    }
  end)

  -- Cycle layout forward
  Input.keybind({ "super" }, key.space, function()
    local op = Output.get_focused()
    if not op then
      return
    end
    for _, t in ipairs(op:tags()) do
      if t:active() then
        layout_cycler:cycle_layout_forward(t)
        layout_requester:request_layout(op)
        break
      end
    end
  end)

  --------------------
  -- Fullscreen
  --------------------
  Input.keybind({ "ctrl" }, key.Return, function()
    local w = Window.get_focused()
    if w then
      w:toggle_fullscreen()
    end
  end)

  --------------------
  -- Application bindings
  --------------------
  Input.keybind({ "super" }, key.Return, function()
    Process.spawn(terminal)
  end)
  Input.keybind({ "super" }, "a", function()
    Process.command({ shell_cmd = { "sh", "-c" }, cmd = { browser } }):spawn()
  end)
  Input.keybind({ "super" }, "k", function()
    Process.spawn("krita")
  end)
  Input.keybind({ "super" }, "o", function()
    Process.spawn("obsidian")
  end)
  Input.keybind({ "super" }, "p", function()
    Process.spawn("protonmail")
  end)
  Input.keybind({ "super" }, "r", function()
    Process.command({ shell_cmd = { "sh", "-c" }, cmd = { menu } }):spawn()
  end)
  Input.keybind({ "super" }, "f", function()
    Process.spawn(fileManager)
  end)
  Input.keybind({ "super" }, "b", function()
    Process.spawn(terminal, "-e", "btop")
  end)
  Input.keybind({ "super" }, "t", function()
    Process.spawn(terminal, "-e", "nvim", "tl.md")
  end)
  Input.keybind({ "super" }, "z", function()
    Process.spawn("zathura")
  end)
  Input.keybind({ "super" }, "s", function()
    Process.command({
      shell_cmd = { "sh", "-c" },
      cmd = { browser .. " --new-window --app=https://search.brave.com" },
    }):spawn()
  end)
  Input.keybind({ "super" }, key.slash, function()
    Process.command({
      shell_cmd = { "sh", "-c" },
      cmd = { browser .. " --new-window --app=https://search.nixos.org/packages" },
    }):spawn()
  end)

  --------------------
  -- Window management
  --------------------
  Input.keybind({ "super" }, "q", function()
    local w = Window.get_focused()
    if w then
      w:close()
    end
  end)
  Input.keybind({ "super" }, "m", function()
    Pinnacle.quit()
  end)
  Input.keybind({ "super", "ctrl" }, "r", function()
    Pinnacle.reload_config()
  end)

  -- Mouse drag: move / resize
  Input.mousebind({ "super" }, "btn_left", function()
    Window.begin_move("btn_left")
  end)
  Input.mousebind({ "super" }, "btn_right", function()
    Window.begin_resize("btn_right")
  end)

  --------------------
  -- Tile resizing
  --------------------
  local resize_step = 50

  -- Super+Minus = shorter height
  Input.keybind({ "super" }, key.minus, function()
    local w = Window.get_focused()
    if w then
      w:resize_tile({ bottom = -resize_step })
    end
  end)
  -- Super+Equal = taller height
  Input.keybind({ "super" }, key.equal, function()
    local w = Window.get_focused()
    if w then
      w:resize_tile({ bottom = resize_step })
    end
  end)
  -- Super+Shift+Minus = narrower width
  Input.keybind({ "super", "shift" }, key.minus, function()
    local w = Window.get_focused()
    if w then
      w:resize_tile({ right = -resize_step })
    end
  end)
  -- Super+Shift+Equal = wider width
  Input.keybind({ "super", "shift" }, key.equal, function()
    local w = Window.get_focused()
    if w then
      w:resize_tile({ right = resize_step })
    end
  end)

  --------------------
  -- Focus with arrow keys
  --------------------
  Input.keybind({ "super" }, key.Left, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("left")
      if targets and targets[1] then
        targets[1]:set_focused(true)
      end
    end
  end)
  Input.keybind({ "super" }, key.Right, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("right")
      if targets and targets[1] then
        targets[1]:set_focused(true)
      end
    end
  end)
  Input.keybind({ "super" }, key.Up, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("up")
      if targets and targets[1] then
        targets[1]:set_focused(true)
      end
    end
  end)
  Input.keybind({ "super" }, key.Down, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("down")
      if targets and targets[1] then
        targets[1]:set_focused(true)
      end
    end
  end)

  --------------------
  -- Move windows (Super+Ctrl+Arrow)
  --------------------
  Input.keybind({ "super", "ctrl" }, key.Left, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("left")
      if targets and targets[1] then
        w:swap(targets[1])
      end
    end
  end)
  Input.keybind({ "super", "ctrl" }, key.Right, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("right")
      if targets and targets[1] then
        w:swap(targets[1])
      end
    end
  end)
  Input.keybind({ "super", "ctrl" }, key.Up, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("up")
      if targets and targets[1] then
        w:swap(targets[1])
      end
    end
  end)
  Input.keybind({ "super", "ctrl" }, key.Down, function()
    local w = Window.get_focused()
    if w then
      local targets = w:in_direction("down")
      if targets and targets[1] then
        w:swap(targets[1])
      end
    end
  end)

  --------------------
  -- Switch to tag (workspaces 1-9, 0)
  --------------------
  local tag_keys = {
    key.KEY_1,
    key.KEY_2,
    key.KEY_3,
    key.KEY_4,
    key.KEY_5,
    key.KEY_6,
    key.KEY_7,
    key.KEY_8,
    key.KEY_9,
    key.KEY_0,
  }

  for i, name in ipairs(tag_names) do
    Input.keybind({ "super" }, tag_keys[i], function()
      local t = Tag.get(name)
      if t then
        t:switch_to()
        -- Notify EWW of workspace change
        Process.spawn("eww", "update", "active_ws=" .. name)
      end
    end)
    Input.keybind({ "super", "shift" }, tag_keys[i], function()
      local w = Window.get_focused()
      local t = Tag.get(name)
      if w and t then
        w:move_to_tag(t)
      end
    end)
  end

  --------------------
  -- Media keys (volume)
  --------------------
  Input.keybind({}, key.XF86AudioRaiseVolume, function()
    Process.spawn("wpctl", "set-volume", "-l", "1", "@DEFAULT_AUDIO_SINK@", "5%+")
  end)
  Input.keybind({}, key.XF86AudioLowerVolume, function()
    Process.spawn("wpctl", "set-volume", "@DEFAULT_AUDIO_SINK@", "5%-")
  end)
  Input.keybind({}, key.XF86AudioMute, function()
    Process.spawn("wpctl", "set-mute", "@DEFAULT_AUDIO_SINK@", "toggle")
  end)
  Input.keybind({}, key.XF86AudioMicMute, function()
    Process.spawn("wpctl", "set-mute", "@DEFAULT_AUDIO_SOURCE@", "toggle")
  end)

  --------------------
  -- Brightness
  --------------------
  Input.keybind({}, key.XF86MonBrightnessUp, function()
    Process.spawn("brightnessctl", "-e4", "-n2", "set", "5%+")
  end)
  Input.keybind({}, key.XF86MonBrightnessDown, function()
    Process.spawn("brightnessctl", "-e4", "-n2", "set", "5%-")
  end)

  --------------------
  -- Playerctl
  --------------------
  Input.keybind({}, key.XF86AudioNext, function()
    Process.spawn("playerctl", "next")
  end)
  Input.keybind({}, key.XF86AudioPause, function()
    Process.spawn("playerctl", "play-pause")
  end)
  Input.keybind({}, key.XF86AudioPlay, function()
    Process.spawn("playerctl", "play-pause")
  end)
  Input.keybind({}, key.XF86AudioPrev, function()
    Process.spawn("playerctl", "previous")
  end)

  --------------------
  -- Window decorations and focus borders
  --------------------
  if Snowcap then
    -- Add focus borders to already existing windows
    for _, win in ipairs(Window.get_all()) do
      Snowcap.integration.focus_border(win):decorate()
    end

    -- Add focus borders to new windows and force server-side decorations (no title bars)
    Window.add_window_rule(function(window)
      window:set_decoration_mode("server_side")
      Snowcap.integration.focus_border(window):decorate()
    end)
  end

  --------------------
  -- Focus follows pointer
  --------------------
  Window.connect_signal({
    pointer_enter = function(window)
      window:set_focused(true)
    end,
  })

  --------------------
  -- Autostart
  --------------------
  Process.set_env("LIBGL_ALWAYS_SOFTWARE", "1")
  Process.set_env("XCURSOR_SIZE", "24")

  -- Ensure user profile bins (eww, nu, etc.) are in PATH for spawned processes
  local home = os.getenv("HOME") or "/home/redironninja"
  local current_path = os.getenv("PATH") or ""
  Process.set_env("PATH", "/etc/profiles/per-user/redironninja/bin:" .. home .. "/.nix-profile/bin:" .. current_path)

  -- Start swww daemon and wallpaper cycle
  Process.spawn_once("swww-daemon")
  Process.command({ shell_cmd = { "sh", "-c" }, cmd = { "sleep 1 && ~/.local/bin/wallpaper-cycle.nu" } }):spawn()
end)
