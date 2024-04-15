#!/bin/bash

files=(*.csv)         #creates an array of all csv files in the current in the current directory
temp=()

for file in ${files[@]}
do
    if [ $file != "main.csv" ]
    then
        temp+=($file)
    fi
done
files=( "${temp[@]}") #resets files array to only hold all csv files other than main.csv
unset temp            #destroys the temp array

# Now 'files' array contains all the csv files except main.csv, i.e. all the csv files that need to be combined

# add(){
    
# }

# cp "${files[0]}" tempmain.csv #initializes the main.csv file with the first csv file in the array, as we need some starting point.
# sort -t "," -k 1 tempmain.csv > tempmain.csv #sorts the main.csv file by the first column
# for file in ${files[@]:1}
# do
#     awk -f new_col.awk $file
#     echo "##############"
# done

names=()
for file in ${files[@]}
do
    names+=($(awk 'BEGIN{FS=",";OFS=","}NR>1{print $1 OFS $2 ";"}' $file ))
    # echo "${names[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '
    # IFS=";" read -r -a names <<< "$(echo "${names[@]}" | tr ';' '\n' | sort -u | tr '\n' ';')"
    # IFS is used to
done

for name in ${names[@]}
do
    echo $name
done