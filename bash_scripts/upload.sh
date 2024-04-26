#!/bin/bash

filepath=$1 #stores the first arugment in the variable filepath
ext=${filepath##*.} #stores the extension of the file in the variable ext
echo $ext
if [[ -f $filepath && $ext == "csv" ]]; then #checks if the file exists
   cp $filepath ./  #if file exists, copies the file to the current directory
else
   echo "csv file does not exist. Enter a valid file path." #prints an error message
fi

