#!/bin/sh
fg="#fcfcfc"
bg="#252525"

barHeight=20
screenWidth=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f1)
screenHeight=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f2)

let top=$screenHeight-20
let left=$screenWidth-650

conky -c ~/.xmonad/scripts/dzenconky_2 | dzen2 -p -ta r -e 'button3=' -fn 'Exo 2-8' -fg "$fg" -bg "$bg" -h $barHeight -w 650 -x $left -y $top