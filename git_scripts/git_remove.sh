#!/bin/bash

remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
if [[ -d $remote_repo_path/stage ]]
then
    read -p "Enter list of files to remove from the staging area (space separated): " files
    files_to_remove=($files)
    for file in ${files_to_remove[@]}
    do
        if [ -f $remote_repo_path/stage/$file ]
        then
            rm $remote_repo_path/stage/$file
            echo "$file removed from staging area."
        else
            echo "$file is not in the staging area."
        fi
    done
else
    echo "No files in the staging area."
fi

