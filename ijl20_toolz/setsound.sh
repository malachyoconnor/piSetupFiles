#!/bin/bash
SINK=output:hdmi-stereo

if  [[ ("$1" == "DP" ) || ( "$1" == "dp" ) || ( "$1" == "displayport") ]] ; then
    SINK=output:hdmi-stereo-extra2
fi

echo Setting your sound output to $SINK

pacmd set-card-profile 0 $SINK
