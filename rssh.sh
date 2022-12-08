#!/bin/bash

touch /home/pi/Desktop/temp
./ijl20_toolz/waitnet.sh

PORT=31122

echo $(date) rssh.sh $PORT trying ssh reverse tunnel

ssh -o ExitOnForwardFailure=yes -f -N -T -R $PORT:localhost:22 mro31@tfc-app9.cl.cam.ac.uk -i /home/pi/.ssh/id_rsa

