{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

let
  accentRgb = "rgb(${builtins.substring 1 6 theme.accent})";
  inactiveRgb = "rgb(${builtins.substring 1 6 theme.selection_background})";

  brave = "brave --ozone-platform=wayland --ozone-platform-hint=wayland --enable-features=TouchpadOverscrollHistoryNavigation";
in
{
  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      # Environment variables
      env = [
        "XCURSOR_SIZE,24"
      ];

      # Input
      input = {
        kb_layout = "us";
        follow_mouse = 1;
        touchpad = {
          natural_scroll = true;
        };
      };

      # cursor = {
      #   theme = "Adwaita";
      #   size = 24;
      # };

      # General
      general = {
        gaps_out = 6;
        gaps_in = 3;
        border_size = 2;
        "col.active_border" = accentRgb;
        "col.inactive_border" = inactiveRgb;
        layout = "dwindle";
      };

      # Decoration
      decoration = {
        rounding = 6;
        active_opacity = 0.85;
        inactive_opacity = 0.8;
        shadow = {
          enabled = true;
          range = 12;
          render_power = 3;
          color = "rgba(00000044)";
        };
        blur = {
          enabled = true;
          size = 6;
          passes = 2;
          new_optimizations = true;
          ignore_opacity = true;
        };
      };

      # Animations
      animations = {
        enabled = true;
        animation = [
          "windows, 1, 2, default"
          "windowsOut, 1, 2, default, popin 80%"
          "fade, 1, 2, default"
          "workspaces, 1, 2, default"
        ];
      };

      # Dwindle layout
      dwindle = {
        pseudotile = true;
        preserve_split = true;
      };

      # Misc
      misc = {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      };

      # Window rules
      windowrule = [
        "border_size 0, match:class .*"
        "no_shadow on, match:class .*"
        "no_blur on, match:class .*"
      ];

      # Autostart
      exec-once = [
        "awww-daemon"
        "sleep 1 && ~/.local/bin/wallpaper-cycle.nu"
      ];

      # Application keybindings
      bind = [
        "SUPER, Return, exec, ghostty"
        "SUPER, A, exec, ${brave}"
        "SUPER, K, exec, krita"
        "SUPER, O, exec, obsidian"
        "SUPER, P, exec, protonmail"
        "SUPER, R, exec, rofi -show drun"
        "SUPER, F, exec, thunar"
        "SUPER, B, exec, ghostty -e btop"
        "SUPER, T, exec, ghostty -e nvim tl.md"
        "SUPER, Z, exec, zathura"
        "SUPER, S, exec, ${brave} --new-window --app=https://search.brave.com"
        "SUPER, Slash, exec, ${brave} --new-window --app=https://search.nixos.org/packages"

        # Window management
        "SUPER, Q, killactive,"
        "SUPER, M, exit,"
        "SUPER, Space, togglesplit,"
        "CTRL, Return, fullscreen,"

        # Screenshot & recording
        '', Print, exec, grim -g "$(slurp)" - | satty -f -''
        "SUPER, Print, exec, mkdir -p ~/Pictures/Screenshots && grim ~/Pictures/Screenshots/$(date +%Y%m%d_%H%M%S).png"
        ''SUPER SHIFT, R, exec, if pgrep -x wf-recorder > /dev/null; then pkill -INT wf-recorder; else mkdir -p ~/Videos/Recordings && wf-recorder -g "$(slurp)" -f ~/Videos/Recordings/$(date +%Y%m%d_%H%M%S).mp4; fi''

        # Focus with arrow keys
        "SUPER, Left, movefocus, l"
        "SUPER, Right, movefocus, r"
        "SUPER, Up, movefocus, u"
        "SUPER, Down, movefocus, d"

        # Move windows (swap)
        "SUPER CTRL, Left, movewindow, l"
        "SUPER CTRL, Right, movewindow, r"
        "SUPER CTRL, Up, movewindow, u"
        "SUPER CTRL, Down, movewindow, d"

        # Tile resizing
        "SUPER, Minus, resizeactive, 0 -50"
        "SUPER, Equal, resizeactive, 0 50"
        "SUPER SHIFT, Minus, resizeactive, -50 0"
        "SUPER SHIFT, Equal, resizeactive, 50 0"

        # Workspaces 1-9
        "SUPER, 1, workspace, 1"
        "SUPER, 2, workspace, 2"
        "SUPER, 3, workspace, 3"
        "SUPER, 4, workspace, 4"
        "SUPER, 5, workspace, 5"
        "SUPER, 6, workspace, 6"
        "SUPER, 7, workspace, 7"
        "SUPER, 8, workspace, 8"
        "SUPER, 9, workspace, 9"
        "SUPER, 0, workspace, 10"

        # Move to workspace
        "SUPER SHIFT, 1, movetoworkspace, 1"
        "SUPER SHIFT, 2, movetoworkspace, 2"
        "SUPER SHIFT, 3, movetoworkspace, 3"
        "SUPER SHIFT, 4, movetoworkspace, 4"
        "SUPER SHIFT, 5, movetoworkspace, 5"
        "SUPER SHIFT, 6, movetoworkspace, 6"
        "SUPER SHIFT, 7, movetoworkspace, 7"
        "SUPER SHIFT, 8, movetoworkspace, 8"
        "SUPER SHIFT, 9, movetoworkspace, 9"
        "SUPER SHIFT, 0, movetoworkspace, 10"

        # Media keys
        ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
        ", XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
        ", XF86AudioNext, exec, playerctl next"
        ", XF86AudioPause, exec, playerctl play-pause"
        ", XF86AudioPlay, exec, playerctl play-pause"
        ", XF86AudioPrev, exec, playerctl previous"
      ];

      # Repeatable binds for volume and brightness
      binde = [
        ", XF86AudioRaiseVolume, exec, wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"
        ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"
        ", XF86MonBrightnessUp, exec, brightnessctl -e4 -n2 set 5%+"
        ", XF86MonBrightnessDown, exec, brightnessctl -e4 -n2 set 5%-"
      ];

      # Mouse bindings
      bindm = [
        "SUPER, mouse:272, movewindow"
        "SUPER, mouse:273, resizewindow"
      ];
    };
  };
}
