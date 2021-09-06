#!/bin/bash

export LC_ALL=C
source $HOME/.cache/wal/colors.sh
i3lock --blur 7 --radius 250 --indicator \
       --inside-color="$color3"40 --insidever-color="$color6"40   --insidewrong-color=ff555540 \
       --ring-color="$background"80 --ringver-color="$background"80 --ringwrong-color=ff555580 \
       --line-color="$color6"80 --separator-color="$background"80 \
       --keyhl-color="$color6"c0 --bshl-color=ff5555ff \
       --verif-color="$background"ff wrong-color="$background"ff --time-color="$background"ff --date-color="$background"ff \
       --verif-text="Unlocking..." --wrong-text="Wrong password" \
       --clock --time-str="%I:%M%p" --time-font="Santana" --time-size=64 --time-pos ix:iy \
       --date-str="%A. %d %B %Y" --date-font="Santana" --date-size=32 --date-pos tx:ty+48
