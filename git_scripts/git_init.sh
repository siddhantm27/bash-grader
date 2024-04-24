#!/bin/bash

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] #checks if the directory gitrepo and file gitreponame exists or not
then
    #if the directory and file already exists, that means that the remote repository has already been initialized.
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    echo "Remote repository already intialized at $remote_repo_path"
    read -p "Do you want to reinitialize the remote repository to the new location? (y/n): " choice
    if [[ $choice == "y" || $choice == "Y" ]]
    then   
        new_remote_repo_path=$1 #file path to the new remote repository
        if [ ! -d $new_remote_repo_path ] #if the directory does not exist
        then
            mkdir $new_remote_repo_path #create the directory
        fi
        cp -r $remote_repo_path/* $new_remote_repo_path #copy the remote repository to the temporary directory
        rm -r $remote_repo_path #remove the old remote repository
        echo "Remote repository reinitialized at $new_remote_repo_path"
        echo "remote_repo_path:$new_remote_repo_path" > ./.gitrepo/.gitreponame #update the path to the remote repository in the file .gitreponame
    fi
else
    #if the directory and file does not exist, that means that the remote repository has not been initialized yet.
    remote_repo_path=$1 #path to remote repo given by the user
    if [ ! -d $remote_repo_path ] #if the directory does not exist
    then
        mkdir $remote_repo_path #create the directory
    fi
    mkdir .gitrepo #create the hidden directory .gitrepo
    echo "remote_repo_path:$remote_repo_path" > ./.gitrepo/.gitreponame   #write the path to the remote repository in the file .gitreponame 
fi

remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')

mkdir -p $remote_repo_path/.ogfiles
cp *.csv $remote_repo_path/.ogfiles

