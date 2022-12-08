#!/bin/bash

~/ijl20_toolz/waitnet.sh

echo $(date) rssh.sh $1 trying ssh reverse tunnel

ssh -o ExitOnForwardFailure=yes -f -N -T -R $1:localhost:22 mro31@tfc-app2.cl.cam.ac.uk


