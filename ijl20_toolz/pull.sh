#!/bin/bash
echo Downloading updates for ~/ijl20_toolz from tfc-app2.cl.cam.ac.uk

rsync -chavz --exclude='.emacs.d/auto-save*' --exclude='*~' ijl20@tfc-app2.cl.cam.ac.uk:~/ijl20_toolz ~

