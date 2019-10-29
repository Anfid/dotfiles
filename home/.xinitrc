#!/bin/sh

# $HOME/.xinitrc
#
# local xinitrc file, used by X sessions started by xinit (startx)

# invoke global xinit
. /etc/X11/xinit/xinitrc

[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources

exec awesome
