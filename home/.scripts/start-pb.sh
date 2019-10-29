#!/bin/bash

export WLAN_IFACE=`iw dev | awk '$1=="Interface"{print $2}'`
export ETH_IFACE=`ip link | awk -F': ' '$0 !~ "lo|vir|wl|^[^0-9]" && $3 ~ "state UP" {print $2}'`

killall -q polybar
while pgrep -x polybar >/dev/null; do sleep 0.3; done

source $HOME/.cache/wal/colors-alpha.sh
MONITORS=$(polybar -m | awk -F: '{print $1}')
for m in $MONITORS; do
  MONITOR=$m polybar -r bottom &
done
