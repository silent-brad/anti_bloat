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
    theme[main_bg]="${theme.bg}"

    # Main text color
    theme[main_fg]="${theme.fg}"

    # Title color for boxes
    theme[title]="${theme.fg}"

    # Highlight color for keyboard shortcuts
    theme[hi_fg]="${theme.primary}"

    # Background color of selected items
    theme[selected_bg]="${theme.overlay}"

    # Foreground color of selected items
    theme[selected_fg]="${theme.warning}"

    # Color of inactive/disabled text
    theme[inactive_fg]="${theme.muted}"

    # Color of text appearing on top of graphs, i.e uptime and current network graph scaling
    theme[graph_text]="${theme.fg}"

    # Misc colors for processes box including mini cpu graphs, details memory graph and details status text
    theme[proc_misc]="${theme.accent}"

    # Cpu box outline color
    theme[cpu_box]="${theme.overlay}"

    # Memory/disks box outline color
    theme[mem_box]="${theme.overlay}"

    # Net up/down box outline color
    theme[net_box]="${theme.overlay}"

    # Processes box outline color
    theme[proc_box]="${theme.overlay}"

    # Box divider line and small boxes line color
    theme[div_line]="${theme.overlay}"

    # Temperature graph colors
    theme[temp_start]="${theme.accent}"
    theme[temp_mid]="${theme.warning}"
    theme[temp_end]="${theme.error}"

    # CPU graph colors
    theme[cpu_start]="${theme.accent}"
    theme[cpu_mid]="${theme.warning}"
    theme[cpu_end]="${theme.error}"

    # Mem/Disk free meter
    theme[free_start]="${theme.error}"
    theme[free_mid]="${theme.warning}"
    theme[free_end]="${theme.accent}"

    # Mem/Disk cached meter
    theme[cached_start]="${theme.info}"
    theme[cached_mid]="${theme.success}"
    theme[cached_end]="${theme.accent}"

    # Mem/Disk available meter
    theme[available_start]="${theme.error}"
    theme[available_mid]="${theme.warning}"
    theme[available_end]="${theme.accent}"

    # Mem/Disk used meter
    theme[used_start]="${theme.accent}"
    theme[used_mid]="${theme.warning}"
    theme[used_end]="${theme.error}"

    # Download graph colors
    theme[download_start]="${theme.accent}"
    theme[download_mid]="${theme.success}"
    theme[download_end]="${theme.info}"

    # Upload graph colors
    theme[upload_start]="${theme.warning}"
    theme[upload_mid]="${theme.secondary}"
    theme[upload_end]="${theme.primary}"

    # Process box color gradient for threads, mem and cpu usage
    theme[process_start]="${theme.accent}"
    theme[process_mid]="${theme.warning}"
    theme[process_end]="${theme.error}"
  '';
}
