#!/bin/sh

# Displays, set_layouts, and toggles layout

set_layout() {
    echo "Set layout to $1"
    [ "$1" == "monocle" ] && bspc desktop -l monocle || bspc desktop -l tiled
    bsp-layout set $1
}

get_layout() {
    case `bspc query -T -d | jq -r .layout` in
        monocle) echo "monocle";;
        tiled) bsp-layout get `bspc query --names -D -d focused`;;
    esac
}

cycle_fwd() {
    echo `get_layout`
    case `get_layout` in
        tall) set_layout rtall;;
        rtall) set_layout wide;;
        wide) set_layout rwide;;
        rwide) set_layout even;;
        even) set_layout tiled;;
        default) set_layout monocle;;
        monocle) set_layout tall;;
        *) echo "Unknown layout";;
    esac
}

cycle_bck() {
    case `get_layout` in
        tall) set_layout monocle;;
        rtall) set_layout tall;;
        wide) set_layout rtall;;
        rwide) set_layout wide;;
        even) set_layout rwide;;
        default) set_layout even;;
        monocle) set_layout tiled;;
        *) echo "Unknown layout";;
    esac
}

display() {
    get_layout
}

case $1 in
    cycle) cycle_fwd;;
    next) cycle_fwd;;
    prev) cycle_bck;;
    display) display "$@";;
    set_layout) set_layout "$@";;
    *) echo "Unknwon option"
esac
