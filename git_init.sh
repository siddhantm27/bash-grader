#!/bin/bash

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
        remote_repo_path=$1 #file path to the new remote repository
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
    remote_repo_path=$1 #path to remote repo given by the user
    if [ ! -d $remote_repo_path ] #if the directory does not exist
    then
        mkdir $remote_repo_path #create the directory
    fi
    mkdir .gitrepo #create the hidden directory .gitrepo
    echo "remote_repo_path:$remote_repo_path" > ./.gitrepo/.gitreponame   #write the path to the remote repository in the file .gitreponame 
fi