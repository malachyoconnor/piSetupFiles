#!/bin/bash
echo Pushing your ~/ijl20_toolz to tfc-app2.cl.cam.ac.uk

rsync -chavz --exclude='.emacs.d/auto-save*' --exclude='*~' ~/ijl20_toolz ijl20@tfc-app2.cl.cam.ac.uk:~

