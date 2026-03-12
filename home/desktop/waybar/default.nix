{ config, lib, pkgs, ... }:

{
  programs.waybar = {
    enable = true;
    systemd.enable = true;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        spacing = 0;
        height = 26;

        modules-left = [ "custom/launcher" "hyprland/workspaces" ];

        modules-center = [ "clock" ];

        modules-right = [ "network" "pulseaudio" "memory" "battery" ];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{icon}";
          format-icons = {
            default = "";
            "1" = "1";
            "2" = "2";
            "3" = "3";
            "4" = "4";
            "5" = "5";
            "6" = "6";
            "7" = "7";
            "8" = "8";
            "9" = "9";
            "0" = "0";
            active = "󱓻";
          };
          persistent_workspaces = {
            "1" = [ ];
            "2" = [ ];
            "3" = [ ];
            "4" = [ ];
            "5" = [ ];
            "6" = [ ];
            "7" = [ ];
            "8" = [ ];
            "9" = [ ];
            "0" = [ ];
          };
        };

        memory = {
          format = "󰍛 {}% [{used}/{total} GB]";
          interval = 5;
        };

        clock = {
          format = "  {:%a, %b %d    %I:%M %p}";
          tooltip = false;
        };

        network = {
          format-disconnected = "󰖪 0% ";
          format-ethernet = "󰈀 100% ";
          format-linked = "{ifname} (No IP)";
          format-wifi = "  {signalStrength}%";
          tooltip-format = "Connected to {essid} {ifname} via {gwaddr}";
        };

        battery = {
          format = "{icon}  {capacity}%  {time}";
          format-charging = "  {capacity}%";
          format-icons = [ "" "" "" "" "" ];
          format-plugged = " {capacity}% ";
          states = {
            critical = 15;
            good = 95;
            warning = 30;
          };
        };

        pulseaudio = {
          format = "{icon} {volume}%";
          format-icons = { default = [ "󰕿" "󰖀" "󰕾" ]; };
          format-muted = "󰝟";
          on-click = "pavucontrol";
          scroll-step = 5;
        };

        "custom/launcher" = {
          format = "";
          tooltip = false;
        };
      };
    };

    style = ./style.css;
  };
}
