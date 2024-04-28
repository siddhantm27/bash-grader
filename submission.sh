#!/bin/bash

command=$1

if [ $command == "upload" ]
then
    if [ $# -ne 2 ] #check if the number of arguments is not equal to 2
    then
        echo "Usage: bash submission.sh upload <filepath>"
        exit 1
    fi
    filepath=$2 #stores the second argument in the variable filepath
    bash bash_scripts/upload.sh $filepath #calls the upload.sh script and passes the filepath as an argument
elif [ $command == "total" ]
then
    if [ $# -ne 1 ] #check if the number of arguments is not equal to 1
    then
        echo "Usage: bash submission.sh total" 
        exit 1
    fi
    awk -f bash_scripts/total.awk ./main.csv > ./temp.csv #calls the total.awk script and stores the output in a temp file
    mv ./temp.csv $(dirname "$0")/main.csv #renames the temp file to main.csv
elif [ $command == "combine" ]
then
    if [ $# -ne 1 ] #check if the number of arguments is not equal to 1
    then
        echo "Usage: bash submission.sh combine"
        exit 1
    fi
    bash combine.sh
elif [ $command == "update" ] 
then
    if [ $# -ne 1 ] #check if the number of arguments is not equal to 1
    then
        echo "Usage: bash submission.sh update"
        exit 1
    fi
    bash update.sh
elif [[ $command == "git_init" ]]
then
    if [[ $# != 2 ]] #check if the number of arguments is not equal to 2
    then
        echo 'Use "bash submission.sh git_init <remote-repo-path>" to initialize a remote repository.'
        exit 1
    fi
    bash git_scripts/git_init.sh $2
elif [[ $command == "git_add" ]]
then
    if [[ $# != 1 ]]
    then
        echo 'Use "bash submission.sh git_add" to stage changes.'
        exit 1
    fi
    bash git_scripts/git_add.sh
elif [[ $command == "git_commit" ]]
then 
    if [[ $# == 3 && $2 == "-m" ]] #checks if the number of arguments is equal to 3 and the second argument is -m
    then
    #shifts the arguments to the left by 2 positions
    shift
    shift
        bash git_scripts/git_commit.sh $@ #calls the git_commit2.sh script and passes the commit message as an argument
    else
        echo 'Use "bash submission.sh git_commit -m <message>" to commit changes.'
    fi
elif [[ $command == "git_checkout" ]]
then
    if [[ $# == 2 ]]
    then
        bash git_scripts/git_checkout.sh $2
    elif [[ $# == 3 && $2 == "-m" ]]
    then
        bash git_scripts/git_checkout.sh $2 $3
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
elif [[ $command == "git_remove" ]]
then
    if [[ $# == 1 ]]
    then
        bash git_scripts/git_remove.sh
    else
        echo 'Use "bash submission.sh git_remove" to remove the repository.'
    fi

elif [[ $command == "stats" ]]
then
    if [[ $# != 1 ]]
    then
        echo 'Use "bash submission.sh stats" to generate statistics.'
        exit 1
    fi
    python3 py_scripts/stats.py
elif [[ $command == "graphs" ]]
then
    if [[ $# != 1 ]]
    then
        echo 'Use "bash submission.sh graphs" to generate graphs.'
        exit 1
    fi
    python3 py_scripts/graphs.py
elif [[ $command == "rank" ]]
then
    if [[ $# == 2 ]] #checks if the number of arguments is equal to 2
    then
        bash bash_scripts/rank.sh $2 #calls the rank.sh script and passes the exam name as an argument
    else
        echo 'Use "bash submission.sh rank <exam-name>" to rank the csv files by marks.'
    fi
elif [[ $command == "report_card" ]]
then
    bash combine.sh
    mkdir -p report_cards
    python3 py_scripts/report_card2.py
else
    echo "Invalid command"
fi
