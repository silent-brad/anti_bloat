{
  config,
  pkgs,
  lib,
  theme,
  ...
}:

{
  programs.btop = {
    enable = true;
    settings = {
      theme_background = false;
      color_theme = "anti_bloat";
    };
  };

  xdg.configFile."btop/themes/anti_bloat.theme".text = ''
    # Auto-generated from theme: ${theme.name}

    # Main background, empty for terminal default, need to be empty if you want transparent background
    theme[main_bg]="${theme.background}"

    # Main text color
    theme[main_fg]="${theme.foreground}"

    # Title color for boxes
    theme[title]="${theme.foreground}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${theme.color1}"

    # Background color of selected items
    theme[selected_bg]="${theme.color0}"

    # Foreground color of selected items
    theme[selected_fg]="${theme.color3}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${theme.color8}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="${theme.foreground}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="${theme.accent}"

    # Cpu box outline color
    theme[cpu_box]="${theme.color0}"

    # Memory/disks box outline color
    theme[mem_box]="${theme.color0}"

    # Net up/down box outline color
    theme[net_box]="${theme.color0}"

    # Processes box outline color
    theme[proc_box]="${theme.color0}"

    # Box divider line and small boxes line color
    theme[div_line]="${theme.color0}"

    # Temperature graph colors
    theme[temp_start]="${theme.accent}"
    theme[temp_mid]="${theme.color3}"
    theme[temp_end]="${theme.color1}"

    # CPU graph colors
    theme[cpu_start]="${theme.accent}"
    theme[cpu_mid]="${theme.color3}"
    theme[cpu_end]="${theme.color1}"

    # Mem/Disk free meter
    theme[free_start]="${theme.color1}"
    theme[free_mid]="${theme.color3}"
    theme[free_end]="${theme.accent}"

    # Mem/Disk cached meter
    theme[cached_start]="${theme.color4}"
    theme[cached_mid]="${theme.color6}"
    theme[cached_end]="${theme.accent}"

    # Mem/Disk available meter
    theme[available_start]="${theme.color1}"
    theme[available_mid]="${theme.color3}"
    theme[available_end]="${theme.accent}"

    # Mem/Disk used meter
    theme[used_start]="${theme.accent}"
    theme[used_mid]="${theme.color3}"
    theme[used_end]="${theme.color1}"

    # Download graph colors
    theme[download_start]="${theme.accent}"
    theme[download_mid]="${theme.color6}"
    theme[download_end]="${theme.color4}"

    # Upload graph colors
    theme[upload_start]="${theme.color3}"
    theme[upload_mid]="${theme.color5}"
    theme[upload_end]="${theme.color1}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${theme.accent}"
    theme[process_mid]="${theme.color3}"
    theme[process_end]="${theme.color1}"
  '';
}
