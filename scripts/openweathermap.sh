#!/bin/sh

# Load environment variables from .env file
if [ -f "$HOME/.config/polybar/.env" ]; then
    export $(grep -v '^#' "$HOME/.config/polybar/.env" | xargs)
else
    echo "Error: .env file not found. Please create .env with your API key."
    exit 1
fi

# Check if WEATHER_API_KEY is set
if [ -z "$WEATHER_API_KEY" ]; then
    echo "Error: WEATHER_API_KEY is not set in .env file."
    exit 1
fi

get_icon() {
    case $1 in
        # Icons for weather-icons
        01d) icon="";;
        01n) icon="";;
        02d) icon="";;
        02n) icon="";;
        03*) icon="";;
        04*) icon="";;
        09d) icon="";;
        09n) icon="";;
        10d) icon="";;
        10n) icon="";;
        11d) icon="";;
        11n) icon="";;
        13d) icon="";;
        13n) icon="";;
        50d) icon="";;
        50n) icon="";;
        *) icon="";
    esac

    echo $icon
}

get_color() {
    temp=$1

    if [ "$temp" -lt 32 ]; then
        color="#7aa2f7"  # Blue for freezing temperatures
    elif [ "$temp" -lt 50 ]; then
        color="#7dcfff"  # Cyan for cold temperatures
    elif [ "$temp" -lt 68 ]; then
        color="#73daca"  # Green for mild temperatures
    elif [ "$temp" -lt 85 ]; then
        color="#e0af68"  # Yellow for warm temperatures
    else
        color="#f7768e"  # Red for hot temperatures
    fi

    echo $color
}

CITY="Lexington,US"
UNITS="imperial"
SYMBOL="°"

API="https://api.openweathermap.org/data/2.5"

# Function to open weather in browser
open_weather() {
    xdg-open "https://openweathermap.org/city/4297983" # Lexington, KY ID
}

# Check if script is called with "open" argument
if [ "$1" = "open" ]; then
    open_weather
    exit 0
fi

if [ -n "$CITY" ]; then
    if [ "$CITY" -eq "$CITY" ] 2>/dev/null; then
        CITY_PARAM="id=$CITY"
    else
        CITY_PARAM="q=$CITY"
    fi

    current=$(curl -sf "$API/weather?appid=$WEATHER_API_KEY&$CITY_PARAM&units=$UNITS")
else
    location=$(curl -sf "https://location.services.mozilla.com/v1/geolocate?key=geoclue")

    if [ -n "$location" ]; then
        location_lat="$(echo "$location" | jq '.location.lat')"
        location_lon="$(echo "$location" | jq '.location.lng')"

        current=$(curl -sf "$API/weather?appid=$WEATHER_API_KEY&lat=$location_lat&lon=$location_lon&units=$UNITS")
    fi
fi

if [ -n "$current" ]; then
    current_temp=$(echo "$current" | jq ".main.temp" | cut -d "." -f 1)
    current_icon=$(echo "$current" | jq -r ".weather[0].icon")
    color=$(get_color "$current_temp")
    echo "%{F$color}%{T4}$(get_icon "$current_icon")%{T-} $current_temp$SYMBOL%{F-}"
fi
