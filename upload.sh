#!/bin/bash

filepath=$1

if [ -f $filepath ]; then
   cp $filepath $(dirname "$0")
else
   echo "Filepath $filepath does not exist. Enter a valid file path."
fi

