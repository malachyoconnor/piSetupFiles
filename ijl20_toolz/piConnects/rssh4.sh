#!/bin/bash

~/ijl20_toolz/waitnet.sh

PORT=31322

echo $(date) rssh.sh $PORT trying ssh reverse tunnel

ssh -o ExitOnForwardFailure=yes -f -N -T -R $PORT:localhost:22 mro31@tfc-app2.cl.cam.ac.uk



