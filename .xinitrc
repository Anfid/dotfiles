#!/bin/sh

# $HOME/.xinitrc
#
# local xinitrc file, used by X sessions started by xinit (startx)

# invoke global X session script
. /etc/X11/Xsession

[[ -f ~/.cache/wal/colors.Xresources ]] && xrdb -merge ~/.cache/wal/colors.Xresources
