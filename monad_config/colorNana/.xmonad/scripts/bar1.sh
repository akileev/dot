#!/bin/sh

barHeight=20

screenWidth=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f1)
screenHeight=$(xrandr -q | grep '*' | awk '{print $1}' | cut -d 'x' -f2)

let width=$screenWidth-650

dzen2 -p -ta l -e 'button3=' -fn 'Exo 2-8' -fg "$1" -bg "$2" -h $barHeight -w $width -y 0
