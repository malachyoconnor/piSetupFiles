#!/bin/bash
echo mounting dsfiles on ~/dsfiles
mkdir -p ~/dsfiles
sshfs ijl20@sftp.ds.cam.ac.uk:/home/ijl20 /home/ijl20/dsfiles
echo done
