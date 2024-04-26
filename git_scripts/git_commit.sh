#!/bin/bash

git_diff(){
    #initialize two arrays to store the new files added and the files modified
    files_added=()
    files_modified=()
    #get the path to the remote repository
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}')
    #iterate through the files in the stage directory
    for file in $(ls $remote_repo_path/stage)
    do
        if [[ -f $remote_repo_path/.ogfiles/$file ]] #check if the file exists in the .ogfiles directory
        then
            diff -u $remote_repo_path/.ogfiles/$file $remote_repo_path/stage/$file > diff_file #store the difference between the two files in a temporary file
            if [[ -s diff_file ]] #check if the file is not empty
            then
                files_modified+=($file) #add the file to the files_modified array, if not empty
            fi
            rm diff_file #remove the temporary file
        else 
            #if the file does not exist in the .ogfiles directory, it is a new file which was added for the first time
            files_added+=($file)
        fi
    done
    #if no files were added or modified, add "None" to the respective arrays
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

    #record the new files added and the files modified to the .git_log file in the remote repository
    echo "New Files Added: "${files_added[@]} >> $remote_repo_path/.git_log
    echo "Files Modified: "${files_modified[@]} >> $remote_repo_path/.git_log
    echo "----------------------------------------" >> $remote_repo_path/.git_log
    #copies the .git_log file to the local repository
    cp $remote_repo_path/.git_log .gitrepo
}

if [[ -d ./.gitrepo && -a ./.gitrepo/.gitreponame ]] #checks if the repo was initialized
then
    remote_repo_path=$(head -n 1 ./.gitrepo/.gitreponame |  awk 'BEGIN{FS=":"}{print $2}') #gets the remote repo path
    if [[ -d $remote_repo_path/stage && ! -z "$(ls -A $remote_repo_path/stage)" ]] #checks if the remote repo has a stage directory and if it is not empty
    then
        commit_message=$@ #sets the 1st argument as the commit message
        mkdir -p $remote_repo_path/commits #creates the commits directory if it does not exist
        commit_id=$(uuidgen -r | tr -dc 'a-z0-9' | head -c 16) #generates a random commit id hash
        mkdir $remote_repo_path/commits/$commit_id #creates a directory with the commit id as the name
        # cp -r $remote_repo_path/stage/* $remote_repo_path/commits/$commit_id
        files_to_commit=$(ls $remote_repo_path/stage) #gets the list of files in the stage directory and stores it in an array

        #records the commit id, date and time, and commit message to the .git_log file in the remote repository
        echo "Commit_ID : $commit_id" >> $remote_repo_path/.git_log
        echo "Date and Time : $(date)" >> $remote_repo_path/.git_log
        echo "Commit Message : $commit_message" >> $remote_repo_path/.git_log
        echo >> $remote_repo_path/.git_log #adds a new line to the .git_log file
        #calls the function git_diff to display the new files added and the files modified comapared to the .ogfiles directory
        git_diff

        if [ ! -f $remote_repo_path/.ogfiles/$file ] #if the file does not exist in the .ogfiles directory in the remote repo
        then
            cp $file $remote_repo_path/.ogfiles #copy the file to the .ogfiles directory in the remote repo
        fi

        for file in ${files_to_commit[@]} #iterates through the array of files_to_commit
        do
            #creates a patch file for each file in the stage directory with its version in the .ogfiles directory
            diff -u $remote_repo_path/.ogfiles/$file $remote_repo_path/stage/$file > $remote_repo_path/commits/$commit_id/$file.patch 
        done
        #iterates through the list of files in the .ogfiles directory
        for file in $(ls *.csv)
        do  
            #records all the csv files present in the working directory to the .files file in the commit directory. This gives a snapshot of the files present in the working directory at the time of the commit.
            echo $file >> $remote_repo_path/commits/$commit_id/.files
        done
        
        #deletes the stage directory after committing
        rm -r $remote_repo_path/stage
    else
        #if the stage directory is empty, there are no files to commit
        echo 'No files in the staging area to commit. Use "./main.sh git_add" to add files'
    fi
else
    #if the remote repository is not initialized
    echo 'Remote repository not initialized yet. Use "./main.sh git_init remote-repo-pathname" to initialize remote repository.'
fi
