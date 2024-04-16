#!/bin/bash

files=(*.csv)         #creates an array of all csv files in the current in the current directory
temp=()

for file in ${files[@]}
do
    if [[ $file != "main.csv" && $file != "tempmain.csv" && $file != "temptempmain.csv" ]]
    then
        temp+=($file)
    fi
done
files=( "${temp[@]}") #resets files array to only hold all csv files other than main.csv
unset temp            #destroys the temp array

# Now 'files' array contains all the csv files except main.csv, i.e. all the csv files that need to be combined


echo -n "Roll_Number,Name" > tempmain.csv
for file in ${files[@]} 
do  
    tempfile=(${file//./ })
    echo -n ",${tempfile[0]}" >> tempmain.csv
done
echo "" >> tempmain.csv

names=()
for file in ${files[@]}
do  
    IFS=";"
    name=("$(awk 'BEGIN{FS=",";OFS=","}NR>1{print $1 OFS $2 ";"}' $file)")
    names+=("$name")
done


for name in "${names[@]}"
do
    echo $name >> tempmain.csv
done

sed -i -E 's/^ *//g' tempmain.csv #remove leading spaces
sed -i -E 's/ *$//g' tempmain.csv #remove succedding spaces
sed -i -E '/^$/d' tempmain.csv #remove empty lines
awk '!seen[$0]++' tempmain.csv > tmp && mv tmp tempmain.csv #remove duplicate records

filenum=${#files[@]}

awk -v num_of_files=$filenum 'BEGIN{
    OFS=","
}
{
    if (NR==1)
    {
        print $0
    }
    else
    {
        printf $0
        for(i=1;i<=num_of_files;i++)
        {
            printf OFS "a"
        }
        printf "\n"
    }
}' tempmain.csv > tmp && mv tmp tempmain.csv 


for file in ${files[@]}
do  
    sed -i -E '/^$/d' $file #remove empty lines
    while IFS="," read -r roll_no name marks
    do  
        filename="${file%.*}"
        awk -v roll=$roll_no -v marks=$marks -v exam=$filename -f combine.awk tempmain.csv > temp && mv temp tempmain.csv
    done < <(tail -n +2 $file)
done

mv tempmain.csv main.csv