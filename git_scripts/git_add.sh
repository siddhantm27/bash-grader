#!/bin/bash

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] #checks if the repo was initialized
then
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}') #gets the remote repo path
    read -p "Enter list of files to add to staging area (space separated): " files #reads the list of files to add to staging area
    files_to_stage=($files) #converts the list of files to an array
    mkdir -p $remote_repo_path/stage #creates the stage directory if it does not exist
    for file in ${files_to_stage[@]} #iterates through the list of files to add to staging area
    do
        if [ -f $file ] #if the file exists in the current directory
        then
            cp $file $remote_repo_path/stage #copy the file to the stage in the remote repo
            echo "$file added to staging area." 
        else
            echo "$file does not exist." #if the file does not exist in the current directory
        fi
    done
else
    echo 'Remote repository not initialized yet. Initialize using "bash submission.sh git_init <remote-repo-path>"' #if the repo was not initialized
fi