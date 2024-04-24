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
    bash git_scripts/git_init.sh $2
elif [[ $command == "git_add" ]]
then
    bash git_scripts/git_add2.sh
elif [[ $command == "git_commit" ]]
then 
    if [[ $# == 3 && $2 == "-m" ]]
    then
        bash git_scripts/git_commit2.sh $3
    else
        echo 'Use "bash submission.sh git_commit -m <message>" to commit changes.'
    fi
elif [[ $command == "git_checkout" ]]
then
    if [[ $# == 2 ]]
    then
        bash git_scripts/git_checkout2.sh $2
    elif [[ $# == 3 && $2 == "-m" ]]
    then
        bash git_scripts/git_checkout2.sh $2 $3
    else
        echo 'Use "bash submission.sh git_checkout <commit_id>" or "bash submission.sh git_checkout -m "<commit-message>"" to checkout a commit.'
    fi
elif [[ $command == "git_log" ]]
then
    if [[ $# == 1 ]]
    then
        bash git_scripts/git_log.sh $2
    else
        echo 'Use "bash submission.sh git_log" to view the log.'
    fi
elif [[ $command == "stats" ]]
then
    python3 py_scripts/stats.py
elif [[ $command == "graphs" ]]
then
    python3 py_scripts/graphs.py
elif [[ $command == "rank" ]]
then
    if [[ $# == 2 ]]
    then
        bash rank.sh $2
    else
        echo 'Use "bash submission.sh rank <exam-name>" to rank the csv files by marks.'
    fi
elif [[ $command == "report_card" ]]
then
    bash combine.sh
    mkdir -p report_cards
    python3 py_scripts/report_card.py
else
    echo "Invalid command"
fi
