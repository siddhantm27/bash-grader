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

    echo "Files Added: "${files_added[@]} >> $remote_repo_path/.git_log
    echo "Files Removed: "${files_removed[@]} >> $remote_repo_path/.git_log
    echo "Files Modified: "${files_modified[@]} >> $remote_repo_path/.git_log
    echo "----------------------------------------" >> $remote_repo_path/.git_log

    rm current_diff_temp file_changes

}

git_diff2(){
    files_added=()
    files_modified=()
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    for file in $(ls $remote_repo_path/stage)
    do
        if [[ -f $remote_repo_path/.ogfiles/$file ]]
        then
            diff -u $remote_repo_path/.ogfiles/$file $remote_repo_path/stage/$file > diff_file
            if [[ -s diff_file ]]
            then
                files_modified+=($file)
            fi
            rm diff_file
        else
            files_added+=($file)
        fi
    done
    if [ ${#files_added[@]} -eq 0 ]
    then
        files_added=("None")
    fi
    if [ ${#files_modified[@]} -eq 0 ]
    then
        files_modified=("None")
    fi
    echo "New files added: "${files_added[@]}
    echo "Files modified: "${files_modified[@]}

    echo "New Files Added: "${files_added[@]} >> $remote_repo_path/.git_log
    echo "Files Modified: "${files_modified[@]} >> $remote_repo_path/.git_log
    echo "----------------------------------------" >> $remote_repo_path/.git_log
}

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] 
then
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    if [[ -d $remote_repo_path/stage && ! -z "$(ls -A $remote_repo_path/stage)" ]]
    then
        commit_message=$1
        mkdir -p $remote_repo_path/commits
        commit_id=$(uuidgen -r | tr -dc 'a-z0-9' | head -c 16)
        mkdir $remote_repo_path/commits/$commit_id
        # cp -r $remote_repo_path/stage/* $remote_repo_path/commits/$commit_id
        files_to_commit=$(ls $remote_repo_path/stage)
        for file in ${files_to_commit[@]}
        do
            diff -u $remote_repo_path/.ogfiles/$file $remote_repo_path/stage/$file > $remote_repo_path/commits/$commit_id/$file.patch
        done
        for file in $(ls $remote_repo_path/.ogfiles)
        do
            echo $file >> $remote_repo_path/commits/$commit_id/.files
        done
        echo "Commit_ID : $commit_id" >> $remote_repo_path/.git_log
        echo "Date and Time : $(date)" >> $remote_repo_path/.git_log
        echo "Commit Message : $commit_message" >> $remote_repo_path/.git_log

        # echo "Commit Message : $commit_message" > $remote_repo_path/commits/$commit_id/.commit_message    
        
        echo >> $remote_repo_path/.git_log
        git_diff2
        
        cp $remote_repo_path/.git_log .gitrepo
        rm -r $remote_repo_path/stage
    else
        echo 'No files in the staging area to commit. Use "./main.sh git_add" to add files'
    fi
else
    echo 'Remote repository not initialized yet. Use "./main.sh git_init remote-repo-pathname" to initialize remote repository.'
fi
