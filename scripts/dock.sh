#!/bin/bash

# Define applications as an array of associative arrays
declare -A apps
apps[firefox]='([name]="firefox" [icon]="" [class]="firefox" [cmd]="firefox")'
apps[kitty]='([name]="kitty" [icon]="" [class]="kitty" [cmd]="kitty")'
apps[thunar]='([name]="thunar" [icon]="" [class]="Thunar" [cmd]="thunar")'
apps[code]='([name]="code" [icon]="" [class]="Code" [cmd]="code")'
apps[obsidian]='([name]="obsidian" [icon]="" [class]="obsidian" [cmd]="flatpak run md.obsidian.Obsidian")'
apps[spotify]='([name]="spotify" [icon]="" [class]="Spotify" [cmd]="flatpak run com.spotify.Client")'

# Colors
color_inactive="#414868"  # Gray for inactive apps
color_running="#7aa2f7"   # Blue for running apps
color_focused="#bb9af7"   # Purple for focused app

# Get the class of the focused window
focused_class=$(xdotool getwindowfocus getwindowclassname)

output=""

for app_name in "${!apps[@]}"; do
    declare -A app
    eval app="${apps[$app_name]}"

    # Add space before icon, but not for the first one
    if [[ -n "$output" ]]; then
        output+="  "
    fi

    if pgrep -f "${app[cmd]##* }" > /dev/null || wmctrl -l | grep -i "${app[name]}" > /dev/null; then
        # Application is running
        if [[ "$focused_class" == *"${app[class]}"* ]]; then
            output+="%{F$color_focused}%{A1:wmctrl -x -a ${app[class]} || ${app[cmd]} &:}${app[icon]}%{A}%{F-}"
        else
            output+="%{F$color_running}%{A1:wmctrl -x -a ${app[class]} || ${app[cmd]} &:}${app[icon]}%{A}%{F-}"
        fi
    else
        # Application is not running
        output+="%{F$color_inactive}%{A1:${app[cmd]} &:}${app[icon]}%{A}%{F-}"
    fi
done
echo "$output"
