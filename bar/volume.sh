#!/bin/bash

mix=`amixer get Master | tail -1`
vol="$(amixer get Master | tail -n1 | sed -r 's/.*\[(.*)%\].*/\1/')"

if [[ $mix == *\[off\]* ]]; then
    icon="^C8^婢"
elif [ "$vol" -gt "70" ]; then
    icon="^C6^墳"
elif [ "$vol" -eq "0" ]; then
    icon="^C8^奔"
else
    icon="^C1^奔"
fi

volstr=`printf "%3s" "$vol"`

echo "$icon $volstr%"

