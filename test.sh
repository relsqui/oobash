#!/bin/bash

source oobash

eval $(new object widget1)
widget1 .size = large
widget1 .color = blue

eval $(new object widget2)
widget2 .size = medium
widget2 .color = green

eval $(new object widget3)
widget3 .size = $(widget1 .size)
widget3 .color = $(widget2 .color)

widget3 .size
widget3 .color
