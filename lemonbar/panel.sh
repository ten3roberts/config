#!/bin/bash
nummon="${1:-1}"
fontsize=10

# Load the colors
for i in {0..15}; do
  eval "color$i=`xrdb -query | grep \"\*color$i:\" | cut -f 2`"
done

bgcolor="#00000000"
fgcolor="$color7"

update_window_title() {
  wnd_title=`xtitle | awk -v len=60 '{ if (length($0) > len) print substr($0, 1, len-3) "..."; else print; }'`
}

update_tags() {
  for (( current=0; current<$nummon; current++ )); do
    update_tags_mon $current
  done
}

update_tags_mon() {
  tag_status=`herbstclient tag_status $1`

  tag_build="%{F$color0}"
  for i in ${tag_status[@]}; do
    name=" ${i:1}"
    case ${i:0:1} in
      # Focused on mon
      '#')
      tag_build="$tag_build%{B$color1}%{F$color0}$name"
      ;;
      # Viewed but unfocused
      '+')
      tag_build="$tag_build%{B$color1}%{F$color0}$name"
      ;;
      # Occupied
      ':')
      tag_build="$tag_build%{B$color0}%{F$color7}$name"
      ;;
      # Urgent
      '!')
      tag_build="$tag_build%{B$color3}%{F$color0}$name"
      ;;
      # On unfocused monitor
      '-')
      tag_build="$tag_build%{B$color0}%{F$color5}$name"
      ;;
      # Focused mon
      '%')
      tag_build="$tag_build%{B$color0}%{F$color5}$name"
      ;;
      # Empty
      *)
      tag_build="$tag_build%{F$color8}%{B$color0}$name"
  esac
  tag_build="$tag_build "
done
tags[$1]=$tag_build
}

update_big() {
  battery=`$HOME/.config/lemonbar/battery.sh`
  date=`date '+W.%V %a %F'`
  mem=`free -h | awk '/^Mem/ { print $3 "/" $2 }' | sed s/i//g`
  spotify=`$HOME/.config/lemonbar/spotify.sh`
  update_tags
}

update_small() {
  volume=`$HOME/.config/lemonbar/volume.sh`
  time=`date '+%H.%M'`
}

event_loop() {
  update_tags
  update_window_title
  update_big
  update_small
  while read line; do
    case $line in
      window_title_changed*)
        update_window_title
        ;;
      focus_changed*)
        update_window_title
        ;;

      tag_flags*)
        update_tags
        ;;
      tag_changed*)
        update_tags
        ;;
      REFRESH_PANEL*BIG*)
        update_big
        ;;
      REFRESH_PANEL*SMALL*)
        update_small
        ;;
    esac

    for (( mon=0; mon<$nummon; mon++ )); do
      echo -ne "%{S$mon}%{F-}%{B-}"

      echo -ne "%{l}${tags[$mon]}%{B$color0}"
      echo -ne " | %{F-}%{B$color0}$wnd_title  "
      echo -ne "%{c}"
      echo -ne "%{B$color3}%{F$color0}  $time  "
      echo -ne "%{B$color2}%{F$color0}  $date  "
      echo -ne "%{r}"
      echo -ne "$volume"
      echo -ne "%{B$color2}%{F$color0}$spotify"
      echo -ne "%{B$color0}%{F-} $battery"
      echo -ne " %{B$color5}%{F$color0} $mem "
      echo -ne "%{B-}%{F-}"
    done
    echo ""

  done 
}

# Format the Panel
herbstclient -i | event_loop | lemonbar -f "Roboto Mono:size=$fontsize" -B $bgcolor -F $fgcolor
# echo "%{S$monitor}Monitor $monitor" | lemonbar -p 
