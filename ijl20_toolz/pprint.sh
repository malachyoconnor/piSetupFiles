#!/bin/bash

if [[ $# == 1 && $1 == *.xml ]] 
then
  xmllint --format $1
  exit 0
fi

if [[ $# == 1 && $1 == *.json ]] 
then
  python -m json.tool $1
  exit 0
fi

echo File not recognized
exit 1

