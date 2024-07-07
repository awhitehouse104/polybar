#!/bin/bash

STATUS=$(playerctl status 2> /dev/null)

if [[ $STATUS == "Playing" || $STATUS == "Paused" ]]; then
    INFO=$(playerctl metadata --format "{{ title }}")
    echo "$INFO"
else
    echo "No player active"
fi
