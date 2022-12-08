#!/bin/bash
SPEAKERS_LEFT="output:hdmi-stereo-extra2"
SPEAKERS_RIGHT="output:hdmi-stereo"

if [ "$1" = "left" ]; then
    pacmd set-card-profile 0 "$SPEAKERS_LEFT"
    echo "Audio output changed to $SPEAKERS_LEFT (Displayport)"
else
    pacmd set-card-profile 0 "$SPEAKERS_RIGHT"
    echo "Audio output changed to $SPEAKERS_RIGHT (HDMI)"
fi

