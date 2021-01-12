#!/bin/bash

vol=`pamixer --get-volume`
muted=`pamixer --get-mute`

if [[ "$muted" == "true" ]]; then
    color="%{B#545862}"
elif [ "$vol" -gt "50" ]; then
    color="%{B#e06c75}"
elif [ "$vol" -eq "0" ]; then
    color="%{B#c678dd}"
else
    color="%{B#61afef}"
fi

volstr=`progressbar.sh 16 + - $vol`

echo -ne "$color $volstr "

