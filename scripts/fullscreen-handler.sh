#!/bin/bash

is_fullscreen() {
    active_window_id=$(xprop -root _NET_ACTIVE_WINDOW | cut -d ' ' -f 5)
    window_state=$(xprop -id "$active_window_id" _NET_WM_STATE)
    if echo "$window_state" | grep -q _NET_WM_STATE_FULLSCREEN; then
        return 0
    else
        return 1
    fi
}

hide_polybar() {
    polybar-msg cmd hide
}

show_polybar() {
    polybar-msg cmd show
}

cleanup() {
    show_polybar
    exit 0
}

# Set up trap to catch SIGTERM
trap cleanup SIGTERM

# Initialize previous state
previous_state=1  # Assume not fullscreen initially

while true; do
    if is_fullscreen; then
        current_state=0  # Fullscreen
    else
        current_state=1  # Not fullscreen
    fi

    # Only act if the state has changed
    if [ $current_state -ne $previous_state ]; then
        if [ $current_state -eq 0 ]; then
            hide_polybar
        else
            show_polybar
        fi
        previous_state=$current_state
    fi

    sleep 1
done
