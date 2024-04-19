#!/bin/bash

git_diff(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    current_commit=$(ls -t $remote_repo_path/commits | head -n 1)
    previous_commit=$(ls -t $remote_repo_path/commits | head -n 2 | tail -n 1)

    diff -r $remote_repo_path/commits/$previous_commit $remote_repo_path/commits/$current_commit > current_diff_temp
    
    files_added=()
    files_removed=()
    files_modified=()
    grep -i "^only" current_diff_temp > file_changes
    while IFS= read -r line; do
        IFS=":" read -r info file <<< $line
        commit=$(echo $info | awk 'BEGIN{FS="/"}{print $NF}')

        if [ $commit == "$current_commit" ]
        then
            files_added+=($file)
        else
            files_removed+=($file)
        fi
    done < file_changes

    grep -i "^diff" current_diff_temp > file_changes
    while IFS= read -r line; do
        file_modified=$(echo $line | awk 'BEGIN{FS="/"}{print $NF}')
        files_modified+=($file_modified)
    done < file_changes

    echo "Files Added: "${files_added[@]}
    echo "Files Removed: "${files_removed[@]}
    echo "Files Modified: "${files_modified[@]}
    rm current_diff_temp file_changes
}

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] 
then
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    if [ -d $remote_repo_path/stage ]
    then
        commit_message=$1
        mkdir -p $remote_repo_path/commits
        commit_id=$(uuidgen -r | tr -dc '0-9' | head -c 16)
        mkdir $remote_repo_path/commits/$commit_id
        cp -r $remote_repo_path/stage/* $remote_repo_path/commits/$commit_id
        echo "Commit_ID : $commit_id" >> $remote_repo_path/.git_log
        echo "Date and Time : $(date)" >> $remote_repo_path/.git_log
        echo "Commit Message : $commit_message" >> $remote_repo_path/.git_log
        echo >> $remote_repo_path/.git_log
        cp $remote_repo_path/.git_log .gitrepo
        rm -r $remote_repo_path/stage
        git_diff
    else
        echo 'No files in the staging area to commit. Use "./main.sh git_add" to add files'
    fi
else
    echo 'Remote repository not initialized yet. Use "./main.sh git_init remote-repo-pathname" to initialize remote repository.'
fi
