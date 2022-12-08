#!/bin/bash
echo $(date) $USER backup $PWD to $1 starting

if [ $# -eq 0 ]
then
    echo usage ./backup.sh backup_directory \(will backup current directory as tar.gz to backup_directory\)
    exit
fi

tar cpzf $1/$USER\_$(date +%Y-%m-%d).tar.gz $PWD

echo $(date) $USER backup $PWB to $1 completed

