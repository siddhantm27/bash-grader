#!/bin/bash


read -p "Enter roll no.: " roll_no #read roll no. from user
read -p "Enter name: " name #read student name from user

next_exam="y" #condition to update marks

#if next_exam is "y", then update marks for another exam. It is first initialised to "y" to update marks for the first time. 

while [[ $next_exam == "y" ]]
do
    read -p "Enter exam: " exam #read exam name from user
    read -p "Enter updated marks: " marks #read updated marks from user

    filename="${exam}.csv" #get the filename of the csv file which contains the records for the user selected exam
    
    awk -v roll=$roll_no -v marks=$marks -v exam=$exam -f update.awk main.csv > temp.csv && mv temp.csv main.csv
    awk -v roll=$roll_no -v marks=$marks 'BEGIN{FS=",";OFS=","}
    {
        if (NR==1)
        {
            print $0
        }
        else
        { 
            if (tolower($1)==tolower(roll))
            {
                $3=marks
                print $0
            }
            else
            {
                print $0
            }
        }
    }' $filename > temp.csv && mv temp.csv $filename

    read -p "Enter Y/y to update marks for another exam, or any other key to exit: " next_exam
    next_exam=$(echo $next_exam | awk '{print tolower($0)}')
done

