#!/bin/bash


if [ $1 == "git_init" ]
then
    if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] #checks if the directory gitrepo and file gitreponame exists or not
    then
        #if the directory and file already exists, that means that the remote repository has already been initialized.
        remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
        echo "Remote repository already intialized at $remote_repo_path"
        read -p "Do you want to reinitialize the remote repository to the new location? (y/n): " choice
        if [[ $choice == "y" || $choice == "Y" ]]
        then   
            mkdir temp #create a temporary directory
            cp -r $remote_repo_path temp #copy the remote repository to the temporary directory
            rm -r $remote_repo_path #remove the old remote repository
            remote_repo_path=$2 #file path to the new remote repository
            if [ ! -d $remote_repo_path ] #if the directory does not exist
            then
                mkdir $remote_repo_path #create the directory
            fi
            cp -r temp $remote_repo_path #move the contents of the old remote repository to the new remote repository
            rm -r temp #remove the temporary directory
            echo "remote_repo_path:$remote_repo_path" > ./.gitrepo/.gitreponame #update the path to the remote repository in the file .gitreponame
        fi
        exit 1
    else
        #if the directory and file does not exist, that means that the remote repository has not been initialized yet.
        remote_repo_path=$2 #path to remote repo given by the user
        if [ ! -d $remote_repo_path ] #if the directory does not exist
        then
            mkdir $remote_repo_path #create the directory
        fi
        mkdir .gitrepo #create the hidden directory .gitrepo
        echo "remote_repo_path:$remote_repo_path" > ./.gitrepo/.gitreponame   #write the path to the remote repository in the file .gitreponame 
    fi
elif [ $1 == "git_add" ]
then
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
                cp $file $remote_repo_path/stage
                echo "$file added to staging area."
            else
                echo "$file does not exist."
            fi
        done
    else
        echo "Remote repository not initialized yet. Please run git_init first."
    fi
elif [ $1 == "git_commit" ]
then
    if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] 
    then
        remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
        if [ -d $remote_repo_path/stage ]
        then
            commit_message=$3
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
        else
            echo 'No files in the staging area to commit. Use "./main.sh git_add" to add files'
        fi
    else
        echo 'Remote repository not initialized yet. Use "./main.sh git_init remote-repo-pathname" to initialize remote repository.'
    fi
fi
