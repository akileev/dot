#!/bin/sh

screenWidth=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f1)
screenHeight=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f2)
barHeight=20

let top=$screenHeight-$barHeight
let width=$screenWidth-650-60

dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg "$1" -bg "$2" -h $barHeight -w $width -y $top -x 60