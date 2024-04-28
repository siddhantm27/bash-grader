#!/bin/bash

continue_update(){
    read -p "Student record not found. Enter Y/y to retry with correct details, A/a to add a new student or any other key to exit: " user_choice
    if [[ $user_choice == "y" || $user_choice == "Y" ]]
    then
        update #if the user wants to retry, calls the update function
    elif [[ $user_choice == "a" || $user_choice == "A" ]]
    then
        add
    else
        #if the user doesnt want to retry, then main.csv is totaled again, if it was totaled before
        last_column=$(awk -F, '{print $NF; exit}' main.csv) #get the last column of the main.csv file
        if [[ $last_column == "Total" ]]
        then
            #call the total.awk script and store the output in a temp file and rename the temp file to main.csv
            awk -f bash_scripts/total.awk main.csv > temp.csv && mv temp.csv main.csv
        fi
    fi
    exit 0
}

update(){
    read -p "Enter roll no.: " roll_no #read roll no. from user
    read -p "Enter name: " name #read student name from user

    next_exam="y" #condition to update marks

    #if next_exam is "y", then update marks for another exam. It is first initialised to "y" to update marks for the first time. 

    while [ $next_exam == "y" ] || [ $next_exam == "Y" ] #both lower and upper cases work
    do  
        #searches the main.csv file for the student record by roll no and stores it in student_record
        student_record=$(grep -i ^$roll_no main.csv)
        #seperates the student record into student_roll_no, student_name and student_all_marks
        IFS="," read -r student_roll_no student_name student_all_marks <<< $student_record
        #checks if the record is not found
        if [ -z "$student_record" ]
        then
            continue_update #if record not found, calls the continue_update function
        elif [ "$name" != "$student_name" ] #if the name doesnt match the student_name from the record
        then
            #confirms if the user meant the student_name from the record
            read -p "Did you mean: $student_name? (y/n):" user_choice
            if [[ $user_choice == "y" || $user_choice == "Y" ]]
            then
                name=$student_name #if user confirms, sets the name to the student_name from the record
            else
                continue_update #if user doesnt confirm, calls the continue_update function again
            fi
        fi
        #if the record is found and the name matches, then the user is asked to enter the exam name and updated marks
        read -p "Enter exam: " exam #read exam name from user
        read -p "Enter updated marks: " marks #read updated marks from user

        filename="${exam}.csv" #get the filename of the csv file which contains the records for the user selected exam
        if [ -f $filename ] #checks if the file/exam exists
        then
            #updates the marks in the main.csv and exam.csv files by calling the update_main.awk and update_exam.awk scripts and their outputs update the exam csv and main.csv files
            awk -v roll=$roll_no -v marks=$marks -v exam=$exam -f update_main.awk main.csv > temp.csv && mv temp.csv main.csv
            awk -v roll=$roll_no -v marks=$marks -f update_exam.awk $filename > temp.csv && mv temp.csv $filename

            #asks the user if they want to update marks for another exam
            read -p "Enter Y/y to update marks for another exam, or any other key to exit: " choice
            #exam and marks are set to empty strings
            exam=""
            marks=""
            #next exam is set to user's choice. if the user wants to update for another exam, next_exam is set to "y" and the loop continues
            next_exam=$choice
        else
            continue_update #if the file/exam doesnt exist, calls the continue_update function
        fi
    done
    #if main.csv was totaled before, then total it again
    last_column=$(awk -F, '{print $NF; exit}' main.csv)
    if [[ $last_column == "Total" ]]
    then
        awk -f bash_scripts/total.awk main.csv > temp.csv && mv temp.csv main.csv
    fi
}

add(){
    read -p "Enter roll no. of new student: " roll_no #read roll no. from user
    read -p "Enter name of new student: " name #read student name from user

    next_exam="y" #condition to add marks

    no_of_columns=$(awk -F, '{print NF; exit}' main.csv) #get the number of columns in the main.csv file
    last_column=$(awk -F, '{print $NF; exit}' main.csv)

    awk -v roll=$roll_no -v name=$name -v col=$no_of_columns 'BEGIN{FS=",";OFS=","}{print $0}END{printf roll OFS name;for(i=1;i<=col-2;i++){printf ",a"}}' main.csv > temp.csv && mv temp.csv main.csv #adds the new student record to the main.csv file

    while [ $next_exam == "y" ] || [ $next_exam == "Y" ] #both lower and upper cases work
    do
        read -p "Enter exam: " exam #read exam name from user
        read -p "Enter updated marks: " marks #read updated marks from user
        
        filename="${exam}.csv" #get the filename of the csv file which contains the records for the user selected exam
        if [ -f $filename ] #checks if the file/exam exists
        then
            echo "$roll_no,$name,$marks" >> $filename #adds the new student record to the exam.csv file

            #updates the marks in the main.csv and exam.csv files by calling the update_main.awk and update_exam.awk scripts and their outputs update the exam csv and main.csv files
            awk -v roll=$roll_no -v marks=$marks -v exam=$exam -f update_main.awk main.csv > temp.csv && mv temp.csv main.csv
            awk -v roll=$roll_no -v marks=$marks -f update_exam.awk $filename > temp.csv && mv temp.csv $filename

            #asks the user if they want to update marks for another exam
            read -p "Enter Y/y to update marks for another exam, or any other key to exit: " choice
            #exam and marks are set to empty strings
            exam=""
            marks=""
            #next exam is set to user's choice. if the user wants to update for another exam, next_exam is set to "y" and the loop continues
            next_exam=$choice
        else
            echo "Exam not found. Please add the exam first." #if the file/exam doesnt exist, print the error message
        fi
    done
    #if main.csv was totaled before, then total it again
    last_column=$(awk -F, '{print $NF; exit}' main.csv)
    if [[ $last_column == "Total" ]]
    then
        awk -f bash_scripts/total.awk main.csv > temp.csv && mv temp.csv main.csv
        
    fi
    exit 0
}
#calls the update function for the first time
update
