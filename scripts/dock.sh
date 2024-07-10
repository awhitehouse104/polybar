#!/bin/bash

# Name should match WM_CLASS name for each application (case insensitive)
apps=("firefox" "kitty" "thunar" "code" "obsidian" "spotify")

# Icons for each application
icons=("" "" "" "" "" "")

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

# Function to generate output for running applications
generate_running_app_output() {
    local app="$1"
    local icon="$2"
    local launch_command="$3"
    local focused_class="$4"
    
    if [[ "${focused_class,,}" == *"$app"* ]]; then
        echo "%{F$color_focused}%{A1:wmctrl -x -a ${app,,} || $launch_command &:}$icon%{A}%{F-}"
    else
        echo "%{F$color_running}%{A1:wmctrl -x -a ${app,,} || $launch_command &:}$icon%{A}%{F-}"
    fi
}

# Get the class of the focused window
focused_class=$(xdotool getwindowfocus getwindowclassname)

output=""
for i in "${!apps[@]}"; do
    app="${apps[$i]}"
    icon="${icons[$i]}"
    launch_command="${launch_commands[$i]}"
    
    # Add space before icon, but not for the first one
    if [ $i -ne 0 ]; then
        output+="  "
    fi
    
   if [ "${app,,}" = "obsidian" ] && pgrep -f "md.obsidian.Obsidian" > /dev/null; then
        output+=$(generate_running_app_output "$app" "$icon" "$launch_command" "$focused_class")
    elif [ "${app,,}" = "spotify" ] && pgrep -f "com.spotify.Client" > /dev/null; then
        output+=$(generate_running_app_output "$app" "$icon" "$launch_command" "$focused_class")
    elif [ "${app,,}" = "thunar" ] && wmctrl -l | grep -i "${app,,}" > /dev/null; then
        output+=$(generate_running_app_output "$app" "$icon" "$launch_command" "$focused_class")
    elif pgrep -x "${app,,}" > /dev/null || pgrep -f "${app,,}" > /dev/null || wmctrl -l | grep -i "${app,,}" > /dev/null; then
        output+=$(generate_running_app_output "$app" "$icon" "$launch_command" "$focused_class")
    else
        output+="%{F$color_inactive}%{A1:$launch_command &:}$icon%{A}%{F-}"
    fi
done
echo "$output"
