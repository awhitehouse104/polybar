#!/bin/bash

# Colors
color_inactive="#414868"  # Gray for inactive apps
color_running="#7aa2f7"   # Blue for running apps
color_focused="#bb9af7"   # Purple for focused app

# Get the class of the focused window
focused_class=$(xdotool getwindowfocus getwindowclassname)

output=""

# Firefox
if pgrep -f "firefox" > /dev/null || wmctrl -l | grep -i "firefox" > /dev/null; then
    if [[ "$focused_class" == *"firefox"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a firefox || firefox &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a firefox || firefox &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:firefox &:}%{A}%{F-}"
fi

output+="  "

# Kitty
if pgrep -f "kitty" > /dev/null || wmctrl -l | grep -i "kitty" > /dev/null; then
    if [[ "$focused_class" == *"kitty"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a kitty || kitty &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a kitty || kitty &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:kitty &:}%{A}%{F-}"
fi

output+="  "

# Thunar
if pgrep -f "thunar" > /dev/null || wmctrl -l | grep -i "Thunar" > /dev/null; then
    if [[ "$focused_class" == *"Thunar"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a Thunar || thunar &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a Thunar || thunar &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:thunar &:}%{A}%{F-}"
fi

output+="  "

# Code - OSS
if pgrep -f "code" > /dev/null || wmctrl -l | grep -i "Code" > /dev/null; then
    if [[ "$focused_class" == *"Code"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a Code || code &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a Code || code &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:code &:}%{A}%{F-}"
fi

output+="  "

# Obsidian (Flatpak)
if pgrep -f "flatpak run md.obsidian.Obsidian" > /dev/null || wmctrl -l | grep -i "obsidian" > /dev/null; then
    if [[ "$focused_class" == *"obsidian"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a obsidian || flatpak run md.obsidian.Obsidian &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a obsidian || flatpak run md.obsidian.Obsidian &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:flatpak run md.obsidian.Obsidian &:}%{A}%{F-}"
fi

output+="  "

# Spotify (Flatpak)
if pgrep -f "flatpak run com.spotify.Client" > /dev/null || wmctrl -l | grep -i "Spotify" > /dev/null; then
    if [[ "$focused_class" == *"Spotify"* ]]; then
        output+="%{F$color_focused}%{A1:wmctrl -x -a Spotify || flatpak run com.spotify.Client &:}%{A}%{F-}"
    else
        output+="%{F$color_running}%{A1:wmctrl -x -a Spotify || flatpak run com.spotify.Client &:}%{A}%{F-}"
    fi
else
    output+="%{F$color_inactive}%{A1:flatpak run com.spotify.Client &:}%{A}%{F-}"
fi

echo "$output"
