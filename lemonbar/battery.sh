#!/bin/bash

# Credit
# https://github.com/Goles/Battery

usage() {
cat <<EOF
battery usage:
  general:
    -h, --help    print this message
    -t            output tmux status bar format
    -z            output zsh prompt format
    -e            don't output the emoji
    -a            output ascii instead of spark
    -b            battery path            default: /sys/class/power_supply/BAT0
    -p            use pmset (more accurate)
  colors:                                                 tmux     zsh
    -g <color>    good battery level      default: 1;32 | green  | 64
    -m <color>    middle battery level    default: 1;33 | yellow | 136
    -w <color>    warn battery level      default: 0;31 | red    | 160
EOF
}

if [[ $1 == '-h' || $1 == '--help' || $1 == '-?' ]]; then
    usage
    exit 0
fi

# For default behavior
setDefaults() {
    pmset_on=0
    ascii_bar='=========='
    emoji=1
    good_color="#a3be8c"
    middle_color="#ebcb8b"
    warn_color="#bf616a"
    connected_color="#88c0d0"
    connected=0
    battery_path=/sys/class/power_supply/BAT0
}


setDefaults
[ -d "$battery_path" ] || { echo "NONE"; exit; }

# Determine battery charge state
battery_charge() {
    case $(uname -s) in
        "Darwin")
            if ((pmset_on)) && command -v pmset &>/dev/null; then
                if [ "$(pmset -g batt | grep -o 'AC Power')" ]; then
                    BATT_CONNECTED=1
                else
                    BATT_CONNECTED=0
                fi
                BATT_PCT=$(pmset -g batt | grep -o '[0-9]*%' | tr -d %)
            else
                while read key value; do
                    case $key in
                        "MaxCapacity")
                            maxcap=$value
                            ;;
                        "CurrentCapacity")
                            curcap=$value
                            ;;
                        "ExternalConnected")
                            if [ $value == "No" ]; then
                                BATT_CONNECTED=0
                            else
                                BATT_CONNECTED=1
                            fi
                            ;;
                    esac
                    if [[ -n "$maxcap" && -n $curcap ]]; then
                        BATT_PCT=$(( 100 * curcap / maxcap))
                    fi
                done < <(ioreg -n AppleSmartBattery -r | grep -o '"[^"]*" = [^ ]*' | sed -e 's/= //g' -e 's/"//g' | sort)
            fi
            ;;
        "Linux")
            case $(cat /etc/*-release) in
                *"Arch Linux"*|*"Ubuntu"*|*"openSUSE"*)
                    battery_state=$(cat $battery_path/energy_now)
                    battery_full=$battery_path/energy_full
                    battery_current=$battery_path/energy_now
                    ;;
                *)
                    battery_state=$(cat $battery_path/status)
                    battery_full=$battery_path/charge_full
                    battery_current=$battery_path/charge_now
                    ;;
            esac
            if [ $battery_state == 'Discharging' ]; then
                BATT_CONNECTED=0
            else
                BATT_CONNECTED=1
            fi
                now=$(cat $battery_current)
                full=$(cat $battery_full)
                BATT_PCT=$((100 * $now / $full))
            ;;
    esac
}

# Apply the correct color to the battery status prompt
apply_colors() {
    # Green
    if ((BATT_CONNECTED)); then
        COLOR=$connected_color
    elif [[ $BATT_PCT -ge 75 ]]; then
            COLOR=$good_color
    # Yellow
    elif [[ $BATT_PCT -ge 25 ]] && [[ $BATT_PCT -lt 75 ]]; then
        COLOR=$middle_color
    # Red
    else
        COLOR=$warn_color
    fi
}

# Print the battery status
print_status() {
    # No battery was found
    [ -z "$BATT_PCT"] && exit
    if ((emoji)) && ((BATT_CONNECTED)); then
        GRAPH="⚡"
    else
        if command -v spark &>/dev/null; then
            sparks=$(spark 0 ${BATT_PCT} 100)
            GRAPH=${sparks:1:1}
        else
            ascii=1
        fi
    fi

    printf "^c%s^%s %s"  "$COLOR" "$BATT_PCT%"  "$GRAPH"
    printf "%%{F%s} %s"  "$COLOR" "$BATT_PCT%"  "$GRAPH"
}

# Read args
while getopts ":g:m:w:tzeab:p" opt; do
    case $opt in
        g)
            good_color=$OPTARG
            ;;
        m)
            middle_color=$OPTARG
            ;;
        w)
            warn_color=$OPTARG
            ;;
        t)
            output_tmux=1
            good_color="green"
            middle_color="yellow"
            warn_color="red"
            ;;
        z)
            output_zsh=1
            good_color="64"
            middle_color="136"
            warn_color="160"
            ;;
        e)
            emoji=0
            ;;
        a)
            ascii=1
            ;;
        p)
            pmset_on=1
            ;;
        b)
            if [ -d $OPTARG ]; then
                battery_path=$OPTARG
            else
                >&2 echo "Battery not found, trying to use default path..."
                if [ ! -d $battery_path ]; then
                    >&2 echo "Default battery path is also unreachable"
                    exit 1
                fi
            fi
            ;;
        \?)
            echo "Invalid option: -$OPTARG"
            exit 1
            ;;
        :)
            echo "Option -$OPTARG requires an argument"
            exit 1
            ;;
    esac
done

battery_charge
apply_colors
print_status
