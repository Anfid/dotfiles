#!/bin/bash

source $HOME/.cache/wal/colors-pb.sh
export WLAN_IFACE=`iw dev | awk '$1=="Interface"{print $2}'`
export ETH_IFACE=`ip link | awk -F': ' '$0 !~ "lo|vir|wl|^[^0-9]" && $3 ~ "state UP" {print $2}'`

pkill polybar
sleep 1
if type "xrandr"; then
  for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
    MONITOR=$m polybar -r bottom &
  done
else
  polybar -r bottom &
fi
