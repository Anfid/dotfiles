#!/bin/bash

export LC_ALL=C
source $HOME/.cache/wal/colors.sh
i3lock --blur 7 --radius 250 --indicator \
       --insidecolor="$color3"40 --insidevercolor="$color6"40   --insidewrongcolor=ff555540 \
       --ringcolor="$background"80 --ringvercolor="$background"80 --ringwrongcolor=ff555580 \
       --linecolor="$color6"80 --separatorcolor="$background"80 \
       --keyhlcolor="$color6"c0 --bshlcolor=ff5555ff \
       --verifcolor="$background"ff wrongcolor="$background"ff --timecolor="$background"ff --datecolor="$background"ff \
       --veriftext="Unlocking..." --wrongtext="Wrong password" \
       --clock --timestr="%I:%M%p" --time-font="Santana" --timesize=64 --timepos ix:iy \
       --datestr="%A. %d %B %Y" --date-font="Santana" --datesize=32 --datepos tx:ty+48
