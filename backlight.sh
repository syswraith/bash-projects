#!/usr/bin/env bash

backlight() {
    if [[ "$1" == "up" ]]; then
        /usr/bin/gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Keyboard.StepUp
    elif [[ "$1" == "down" ]]; then
        /usr/bin/gdbus call --session --dest org.gnome.SettingsDaemon.Power --object-path /org/gnome/SettingsDaemon/Power --method org.gnome.SettingsDaemon.Power.Keyboard.StepDown
    else
        echo "Usage: backlight {up|down}"
    fi
}

backlight "$1"

