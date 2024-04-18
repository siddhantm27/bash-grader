#!/bin/bash

read -p "Enter roll no.: " roll_no
read -p "Enter name: " name

next_exam="y"
while [[ $next_exam == "y" ]]
do
    read -p "Enter exam: " exam
    read -p "Enter updated marks: " marks

    filename="${exam}.csv"

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

