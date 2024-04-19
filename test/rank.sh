#!/bin/bash

filename="$1.csv"

add_ranks(){
    awk 'BEGIN{
        FS=","
        OFS=","
    }
    {
    if (NR == 1) {
        print "Rank" OFS $0
    }
    else {
        print NR-1 OFS $0
    }
    }' $1
}

if [[ $filename == "main.csv" ]]
then
    if [[ ! -f main.csv ]]
    then
        echo "main.csv does not exist"
        exit 1
    fi
    bash submission.sh total
    no_of_columns=$(awk -F, '{print NF; exit}' main.csv)
    head -n 1 main.csv > temp.csv
    tail -n+2 main.csv | sort -k ${no_of_columns},${no_of_columns}nr -k 1,1 -t, >> temp.csv
    add_ranks temp.csv > main.csv
    rm temp.csv
elif [[ -f $filename ]]
then
    head -n 1 $filename > temp.csv
    tail -n+2 $filename | sort -k 3,3nr -k 1,1 -t, >> temp.csv
    add_ranks temp.csv > $filename
    rm temp.csv
else
    echo "File does not exist"
fi

