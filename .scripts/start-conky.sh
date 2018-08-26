#!/bin/bash

export LC_ALL=C

sleep 10 #time (in s) for the DE to start; use ~20 for Gnome or KDE, less for Xfce/LXDE etc
conky -c $HOME/.conky/rings & # the main conky with rings
conky -c $HOME/.conky/cava &
sleep 8 #time for the main conky to start; needed so that the smaller ones draw above not below (probably can be lower, but we still have to wait 5s for the rings to avoid segfaults)
conky -c $HOME/.conky/cpu &
sleep 1
conky -c $HOME/.conky/mem &
conky -c $HOME/.conky/notes &
