#!/usr/bin/env nu

let theme_dir = $"($env.HOME)/Pictures/Wallpapers/@themeName@"
let fallback_dir = $"($env.HOME)/Pictures/Wallpapers"
let wallpaper_dir = if ($theme_dir | path exists) { $theme_dir } else { $fallback_dir }
let interval = 10000sec

swww-daemon &
sleep 1sec

loop {
  let images = (glob $"($wallpaper_dir)/**/*.{jpg,png,jpeg,gif,webp}")
  if ($images | is-not-empty) {
    let wallpaper = ($images | shuffle | first)
    let transitions = [wipe wave grow outer random]
    let transition = ($transitions | shuffle | first)
    swww img $wallpaper --transition-type $transition --transition-duration 2
  }
  sleep $interval
}
