#!/bin/bash

#function for checking out a commit using the commit hash
hash(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}') #gets the path to the remote repository
    commit_id=$1 #commit hash
    commit_id=$(grep "Commit_ID : $commit_id" ./.gitrepo/.git_log | awk 'BEGIN{FS=":"}{print $2}'|tr -d ' ') #gets the commit id from the git log
    possible_commit_ids=$(echo $commit_id | wc -w) #counts the number of possible commit ids which match with the user input
    if [ $possible_commit_ids -gt 1 ] #if the number of commit ids is greater than 1
    then
        echo Possible Commit IDs: $commit_id. Retry with a closer match. #print the possible commit ids
        exit 0
    fi
    if [[ -d $remote_repo_path/commits/$commit_id ]] #if the directory for the commit id exists
    then
        patch_files=$(ls $remote_repo_path/commits/$commit_id) #list all the patch files in the directory
        rm ./*.csv #remove all the csv files in the current directory
        mapfile -t files_to_checkout < $remote_repo_path/commits/$commit_id/.files #get the array of files to checkout
        for file in ${files_to_checkout[@]} #for each file in files_to_checkout
        do  
            #if the patch file exists and is not empty
            if [[ -f $remote_repo_path/commits/$commit_id/${file}.patch && -s $remote_repo_path/commits/$commit_id/${file}.patch ]]
            then
                #apply the patch file to the file in .ogfiles and get the original file i.e. the version of the file at that commit. you also get the .orig file due to the -b flag
                patch -b $remote_repo_path/.ogfiles/$file $remote_repo_path/commits/$commit_id/$file.patch
                mv $remote_repo_path/.ogfiles/$file ./ #move the file to the current directory
                mv "$remote_repo_path/.ogfiles/${file}.orig" "$remote_repo_path/.ogfiles/$file" #rename the .orig file to the original file name i.e. remove the .orig extension
            else
                if [[ -f $remote_repo_path/.ogfiles/$file ]] #if the file exists in the .ogfiles directory
                then
                    cp $remote_repo_path/.ogfiles/$file $PWD #copy the file to the current directory
                fi
            fi
        done
        echo "Checked out commit-id : $commit_id" #print the message
        echo $commit_id > ./.gitrepo/.githead #update the commit id of the head in the .githead file
    else
        echo "Commit id not found" #if the commit id is not found
    fi
}

#function for checking out a commit using the commit message
message(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}') #gets the path to the remote repository
    commit_message=$1 #commit message
    commmit_line_no=$(grep -n "Commit Message : $commit_message" $remote_repo_path/.git_log | awk 'BEGIN{FS=":"}{print $1}') #get the line number of the commit message in the git log
    commit_id_no=$(($commmit_line_no - 2)) #get the line number of the commit id in the git log by subtracting 2 from the line number of the commit message
    commit_id=$(sed "${commit_id_no}q;d" ./.gitrepo/.git_log | awk 'BEGIN{FS=":"}{print $2}'|tr -d ' ') #get the commit id from the git log
    if [[ -d $remote_repo_path/commits/$commit_id ]] #if the directory for the commit id exists
    then
        patch_files=$(ls $remote_repo_path/commits/$commit_id) #list all the patch files in the directory
        rm ./*.csv #remove all the csv files in the current directory
        mapfile -t files_to_checkout < $remote_repo_path/commits/$commit_id/.files #get the array of files to checkout
        for file in ${files_to_checkout[@]}  #for each file in files_to_checkout
        do  
            #if the patch file exists and is not empty
            if [[ -f $remote_repo_path/commits/$commit_id/${file}.patch && -s $remote_repo_path/commits/$commit_id/${file}.patch ]]
            then
                #apply the patch file to the file in .ogfiles and get the original file i.e. the version of the file at that commit. you also get the .orig file due to the -b flag
                patch -b $remote_repo_path/.ogfiles/$file $remote_repo_path/commits/$commit_id/$file.patch
                cp $remote_repo_path/.ogfiles/$file ./ #copy the file to the current directory
                mv $remote_repo_path/.ogfiles/${file}.orig $remote_repo_path/.ogfiles/$file #rename the .orig file to the original file name i.e. remove the .orig extension

            fi
            cp $remote_repo_path/.ogfiles/$file ./ #copy the file to the current directory
        done
        echo switched to commit-id : $commit_id #print the commit id
        echo $commit_id > ./.gitrepo/.githead #update the commit id of the head in the .githead file
    else
        echo "Commit id not found" #if the commit id is not found
    fi
}

if [[ $# == 1 ]] #if the number of arguments is 1
then
    hash $1 #call the function hash with the argument $1
elif [[ $# == 2 ]] #if the number of arguments is 2
then
    message $2 #call the function message with the argument $2
else
    echo "Invalid number of arguments"
fi