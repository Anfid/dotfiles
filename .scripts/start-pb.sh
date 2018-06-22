#!/bin/bash

source $HOME/.cache/wal/colors-pb.sh

pkill polybar
sleep 0.5
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar bottom &
  done
else
  polybar bottom &
fi
