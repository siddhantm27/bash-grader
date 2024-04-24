#!/bin/bash

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] 
then
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    read -p "Enter list of files to add to staging area (space separated): " files
    files_to_stage=($files)
    mkdir -p $remote_repo_path/stage
    for file in ${files_to_stage[@]}
    do
        if [ -f $file ] 
        then
            if [ ! -f $remote_repo_path/.ogfiles/$file ]
            then
                cp $file $remote_repo_path/.ogfiles
            fi
            cp $file $remote_repo_path/stage
            echo "$file added to staging area."
        else
            echo "$file does not exist."
        fi
    done
else
    echo "Remote repository not initialized yet. Please run git_init first."
fi