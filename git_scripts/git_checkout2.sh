#!/bin/bash

hash(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    commit_id=$1
    commit_id=$(grep "Commit_ID : $commit_id" ./.gitrepo/.git_log | awk 'BEGIN{FS=":"}{print $2}'|tr -d ' ')
    possible_commit_ids=$(echo $commit_id | wc -w)
    if [ $possible_commit_ids -gt 1 ]
    then
        echo Possible Commit IDs: $commit_id. Retry with a closer match.
        exit 0
    fi
    if [[ -d $remote_repo_path/commits/$commit_id ]]
    then
        patch_files=$(ls $remote_repo_path/commits/$commit_id)
        rm ./*.csv
        mapfile -t files_to_checkout < $remote_repo_path/commits/$commit_id/.files
        for file in ${files_to_checkout[@]}
        do  
            if [[ -f $remote_repo_path/commits/$commit_id/${file}.patch && -s $remote_repo_path/commits/$commit_id/${file}.patch ]]
            then
                patch -b $remote_repo_path/.ogfiles/$file $remote_repo_path/commits/$commit_id/$file.patch
                echo "--------------------------"
                echo $(ls $remote_repo_path/.ogfiles)
                echo "--------------------------"
                cp $remote_repo_path/.ogfiles/$file ./
                mv "$remote_repo_path/.ogfiles/${file}.orig" "$remote_repo_path/.ogfiles/$file"
            fi
            cp $remote_repo_path/.ogfiles/$file ./
        done
    else
        echo "Commit id not found"
    fi
}

message(){
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    commit_message=$1
    commmit_line_no=$(grep -n "Commit Message : $commit_message" $remote_repo_path/.git_log | awk 'BEGIN{FS=":"}{print $1}')
    commit_id_no=$(($commmit_line_no - 2))
    commit_id=$(sed "${commit_id_no}q;d" ./.gitrepo/.git_log | awk 'BEGIN{FS=":"}{print $2}'|tr -d ' ')
    if [[ -d $remote_repo_path/commits/$commit_id ]]
    then
        patch_files=$(ls $remote_repo_path/commits/$commit_id)
        rm ./*.csv
        mapfile -t files_to_checkout < $remote_repo_path/commits/$commit_id/.files
        for file in ${files_to_checkout[@]}
        do  
            if [[ -f $remote_repo_path/commits/$commit_id/${file}.patch && -s $remote_repo_path/commits/$commit_id/${file}.patch ]]
            then
                patch -b $remote_repo_path/.ogfiles/$file $remote_repo_path/commits/$commit_id/$file.patch
                cp $remote_repo_path/.ogfiles/$file ./
                mv $remote_repo_path/.ogfiles/${file}.orig $remote_repo_path/.ogfiles/$file
            fi
            cp $remote_repo_path/.ogfiles/$file ./
        done
    else
        echo "Commit id not found"
    fi
}

if [[ $# == 1 ]]
then
    hash $1
else
    message $2
fi