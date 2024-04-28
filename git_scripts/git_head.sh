#!/bin/bash

if [[ -d .gitrepo ]]
then
    if [[ -f .gitrepo/.githead ]]
    then
        head=$(cat .gitrepo/.githead)
        echo "HEAD: $head"
    else
        echo "No commits yet."
    fi
else
    echo "Remote repository not initialized. Use 'bash submission.sh git_init <remote-repo-path>' to initialize a remote repository."
    exit 1
fi