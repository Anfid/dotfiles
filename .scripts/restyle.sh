#!/bin/bash

if [[ -f $HOME/.config/i3/.wallpaper ]]
  then rm -f $HOME/.config/i3/.wallpaper
fi
find $HOME/Pictures/Wallpapers -type f | shuf | head -n1 >> $HOME/.config/i3/.wallpaper

export WALLPAPER="$(< $HOME/.config/i3/.wallpaper)"

wal -g -i $WALLPAPER
