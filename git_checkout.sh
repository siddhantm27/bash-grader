#!/bin/bash

hash(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    commit_id=$1
    if [[ -d $remote_repo_path/commits/$commit_id ]]
    then
        rm *.csv
        cp -r $remote_repo_path/commits/$commit_id/* .
    else
        echo "Commit id not found"
    fi
}

message(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    commit_message=$1
    commmit_line_no=$(grep -n "Commit Message : $commit_message" $remote_repo_path/.git_log | awk 'BEGIN{FS=":"}{print $1}')
    commit_id_no=$(($commmit_line_no - 2))
    commit_id=$(sed "${commit_id_no}q;d" .gitrepo/.git_log | awk 'BEGIN{FS=":"}{print $2}')
    if [[ -d $remote_repo_path/commits/$commit_id ]]
    then
        rm *.csv
        cp -r $remote_repo_path/commits/$commit_id/* .
    else
        echo "Commit id not found"
    fi
}


if [[ $# == 1 ]]
then
    hash $1
else
    message $2
fi