#!/bin/bash - 
#===============================================================================
#
#          FILE: lock.sh
# 
#         USAGE: ./lock.sh 
# 
#   DESCRIPTION: script used to lock the pc
# 
#       OPTIONS: ---
#  REQUIREMENTS: ---
#          BUGS: ---
#         NOTES: ---
#        AUTHOR: Eshan Shafeeq (), eshanshafeeq073055@gmail.com
#  ORGANIZATION: 
#       CREATED: 06/21/2018 12:09:00 AM
#      REVISION:  ---
#===============================================================================

set -o nounset                              # Treat unset variables as an error

SCREENSHOT=/tmp/screenshot.png
LOGO=~/tmp/wallpapers/archlinux.svg

# take a screenshot using scrot
scrot $SCREENSHOT

# put some magic on the screenshot
convert $SCREENSHOT -paint 1 -swirl 360 $SCREENSHOT

# add the archlinux logo
if [[ -f $LOGO ]]
then
    convert $SCREENSHOT $LOGO -gravity center -composite -matte $SCREENSHOT
fi

# lock it up
i3lock -e -f -c 000000 -i $SCREENSHOT



