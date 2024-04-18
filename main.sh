#!/bin/bash

command=$1

if [ $command == "upload" ]
then
    filepath=$2
    bash $(dirname "$0")/upload.sh $filepath
elif [ $command == "total" ]
then
    awk -f $(dirname "$0")/total.awk $(dirname "$0")/main.csv > $(dirname "$0")/temp.csv
    mv $(dirname "$0")/temp.csv $(dirname "$0")/main.csv
elif [ $command == "combine" ]
then
    bash combine.sh
elif [ $command == "update" ]
then
    bash update.sh
elif [[ $command == "git_init" ]]
then
    bash git.sh $1 $2
else
    echo "Invalid command"
fi
