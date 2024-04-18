#!/bin/bash


if [ $1 == "git_init" ]
then
    if [[ -d ./gitrepo && -f ./.gitrepo/.gitreponame ]]
    then
        remote_repo_path=$(head -n 1 ./gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
        echo "Remote repository already intialized at $remote_repo_path"
        exit 1
    else
        remote_repo_path=$2
        if [ ! -d $remote_repo_path ]
        then
            mkdir $remote_repo_path
        fi
        echo "remote_repo_path:$remote_repo_path" > .gitrepo      
    fi
elif [[ $1 == "git_commit" ]]
then
    if [[ -f .gitrepo ]]

if 
