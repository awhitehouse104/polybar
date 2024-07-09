#!/bin/bash

# List of applications to monitor
apps=("firefox" "kitty" "thunar" "code" "obsidian" "spotify")

# Icons for each application (ensure these are available in your font)
icons=("" "" "" "" "" "")

# WM_CLASS names for each application (used for more accurate window detection)
classes=("firefox" "kitty" "Thunar" "Code" "obsidian" "spotify")

# Launch commands
launch_commands=(
    "firefox"
    "kitty"
    "thunar"
    "code"
    "flatpak run md.obsidian.Obsidian"
    "flatpak run com.spotify.Client"
)

# Colors
color_inactive="#414868"  # Gray for inactive apps
color_running="#7aa2f7"   # Blue for running apps
color_focused="#bb9af7"   # Purple for focused app

# Get the class of the focused window
focused_class=$(xdotool getwindowfocus getwindowclassname)

output=""
for i in "${!apps[@]}"; do
    app="${apps[$i]}"
    icon="${icons[$i]}"
    class="${classes[$i]}"
    launch_command="${launch_commands[$i]}"
    
    # Add space before icon, but not for the first one
    if [ $i -ne 0 ]; then
        output+="  "
    fi
    
    if [ "$app" = "obsidian" ]; then
        # Special handling for Obsidian (Flatpak)
        if pgrep -f "md.obsidian.Obsidian" > /dev/null || wmctrl -l | grep -i "obsidian" > /dev/null; then
            if [[ "$focused_class" == *"obsidian"* ]]; then
                output+="%{F$color_focused}%{A1:wmctrl -x -a obsidian || $launch_command &:}$icon%{A}%{F-}"
            else
                output+="%{F$color_running}%{A1:wmctrl -x -a obsidian || $launch_command &:}$icon%{A}%{F-}"
            fi
        else
            output+="%{F$color_inactive}%{A1:$launch_command &:}$icon%{A}%{F-}"
        fi
    elif [ "$app" = "spotify" ]; then
        # Special handling for Spotify (Flatpak)
        if pgrep -f "com.spotify.Client" > /dev/null || wmctrl -l | grep -i "spotify" > /dev/null; then
            if [[ "$focused_class" == *"Spotify"* ]]; then
                output+="%{F$color_focused}%{A1:wmctrl -x -a spotify || $launch_command &:}$icon%{A}%{F-}"
            else
                output+="%{F$color_running}%{A1:wmctrl -x -a spotify || $launch_command &:}$icon%{A}%{F-}"
            fi
        else
            output+="%{F$color_inactive}%{A1:$launch_command &:}$icon%{A}%{F-}"
        fi
    elif [ "$app" = "thunar" ]; then
        # Special handling for Thunar
        if pgrep -x "thunar" > /dev/null || wmctrl -l | grep -i "thunar" > /dev/null; then
            if [[ "$focused_class" == *"$class"* ]]; then
                output+="%{F$color_focused}%{A1:wmctrl -x -a Thunar || thunar &:}$icon%{A}%{F-}"
            else
                output+="%{F$color_running}%{A1:wmctrl -x -a Thunar || thunar &:}$icon%{A}%{F-}"
            fi
        else
            output+="%{F$color_inactive}%{A1:thunar &:}$icon%{A}%{F-}"
        fi
    elif pgrep -x "$app" > /dev/null || pgrep -f "$app" > /dev/null; then
        # Application is running
        if [[ "$focused_class" == *"$class"* ]]; then
            output+="%{F$color_focused}%{A1:wmctrl -x -a $class || $launch_command &:}$icon%{A}%{F-}"
        else
            output+="%{F$color_running}%{A1:wmctrl -x -a $class || $launch_command &:}$icon%{A}%{F-}"
        fi
    else
        # Application is not running
        output+="%{F$color_inactive}%{A1:$launch_command &:}$icon%{A}%{F-}"
    fi
done

echo "$output"
