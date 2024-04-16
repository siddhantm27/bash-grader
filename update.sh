#!/bin/bash

read -p "Enter roll no.: " roll_no
read -p "Enter name: " name
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
        if ($1==roll)
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

