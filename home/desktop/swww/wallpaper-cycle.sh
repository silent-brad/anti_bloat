#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/Pictures/Wallpapers"
INTERVAL=10000

swww-daemon &
sleep 1

while true; do
  WALLPAPER=$(find "$WALLPAPER_DIR" -type f \( -name "*.jpg" -o -name "*.png" -o -name "*.jpeg" -o -name "*.gif" \) | shuf -n 1)
  if [ -n "$WALLPAPER" ]; then
    TRANSITION=$(echo "wipe,wave,grow,outer,random" | tr ',' '\n' | shuf -n 1)
    swww img "$WALLPAPER" --transition-type "$TRANSITION" --transition-duration 2
  fi
  sleep "$INTERVAL"
done
