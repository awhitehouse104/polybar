#!/bin/bash

PLAY_ICON=""
PAUSE_ICON=""

STATUS=$(playerctl status 2> /dev/null)

if [[ $STATUS == "Playing" ]]; then
    echo "$PLAY_ICON"
elif [[ $STATUS == "Paused" ]]; then
    echo "$PAUSE_ICON"
else
    echo "$PLAY_ICON"
fi
