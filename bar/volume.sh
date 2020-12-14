#!/bin/bash

vol=`pamixer --get-volume`
muted=`pamixer --get-mute`

if [[ "$muted" == "true" ]]; then
    icon="^C8^婢"
elif [ "$vol" -gt "70" ]; then
    icon="^C6^墳"
elif [ "$vol" -eq "0" ]; then
    icon="^C8^奔"
else
    icon="^C1^奔"
fi

volstr=`printf "%2s" "$vol"`

echo "$icon $volstr%"

