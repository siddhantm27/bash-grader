#!/bin/bash

filepath=$1

if [ -f $filepath ]; then
   cp $filepath ./
else
   echo "File does not exist. Enter a valid file path."
fi

