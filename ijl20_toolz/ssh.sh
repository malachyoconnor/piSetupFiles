#/bin/bash

if [ -z "$1" ]
then
  ssh -p 8022 ijl20@localhost
elif [ "$1" == "ijl20-iot" ]
then
  ssh -p 8023 ijl20@localhost
elif [ "$1" == "ijl20-dell7040" ]
then
  ssh -p 8022 ijl20@localhost
elif [ "$1" == "coffee" ]
then
  ssh -p 8024 pi@localhost
else
  echo "Unknown host $1"
fi

