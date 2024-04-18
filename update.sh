#!/bin/bash

continue_update(){
    read -p "Student record not found. Enter Y/y to retry with correct details or any other key to exit: " user_choice
    if [[ $user_choice == "y" || $user_choice == "Y" ]]
    then
        update
    else
        exit 0
    fi
}

update(){
    read -p "Enter roll no.: " roll_no #read roll no. from user
    read -p "Enter name: " name #read student name from user

    next_exam="y" #condition to update marks

    #if next_exam is "y", then update marks for another exam. It is first initialised to "y" to update marks for the first time. 

    while [ $next_exam == "y" ] || [ $next_exam == "Y" ]
    do  
        echo $next_exam
        student_record=$(grep -i ^$roll_no main.csv)
        IFS="," read -r student_roll_no student_name student_all_marks <<< $student_record
        if [ -z "$student_record" ]
        then
            continue_update
        elif [ "$name" != "$student_name" ]
        then
            read -p "Did you mean: $student_name? (y/n):" user_choice
            if [[ $user_choice == "y" || $user_choice == "Y" ]]
            then
                name=$student_name
            else
                continue_update
            fi
        fi
        read -p "Enter exam: " exam #read exam name from user
        read -p "Enter updated marks: " marks #read updated marks from user

        filename="${exam}.csv" #get the filename of the csv file which contains the records for the user selected exam
        if [ -f $filename ]
        then
            awk -v roll=$roll_no -v marks=$marks -v exam=$exam -f update_main.awk main.csv > temp.csv && mv temp.csv main.csv
            awk -v roll=$roll_no -v marks=$marks -f update_exam.awk $filename > temp.csv && mv temp.csv $filename

            read -p "Enter Y/y to update marks for another exam, or any other key to exit: " choice
            exam=""
            marks=""
            next_exam=$choice
            echo $next_exam
        else
            continue_update
        fi
    done
    exit 0
}

update