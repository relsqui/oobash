#!/bin/bash

source oobash

alias widget1=$(new object)
widget1 .size = large
widget1 .color = blue

alias widget2=$(new object)
widget2 .size = medium
widget2 .color = green

widget1 .size
widget2 .size
