#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}

run setxkbmap -layout us,ru -option 'grp:alt_shift_toggle'
run compton
run dunst -conf $HOME/.config/dunst/dunstrc
run cava -p $HOME/.config/cava/raw

run telegram-desktop
run slack
