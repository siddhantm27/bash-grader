#!/bin/bash

files=(*.csv)         #creates an array of all csv files in the current in the current directory
temp=()

for file in ${files[@]}
do
    if [[ $file != "main.csv" && $file != "tempmain.csv" ]]
    then
        temp+=($file)
    fi
done
files=( "${temp[@]}") #resets files array to only hold all csv files other than main.csv
unset temp            #destroys the temp array

# Now 'files' array contains all the csv files except main.csv, i.e. all the csv files that need to be combined

# add(){

echo -n "Roll_Number,Name" > tempmain.csv
for file in ${files[@]} 
do  
    tempfile=(${file//./ })
    echo -n ",${tempfile[0]}" >> tempmain.csv
done
echo "" >> tempmain.csv
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
    IFS=";"
    name=("$(awk 'BEGIN{FS=",";OFS=","}NR>1{print $1 OFS $2 ";"}' $file)")
    # echo $name
    names+=("$name")
    # echo "${names[@]}" | tr ' ' '\n' | sort -u | tr '\n' ' '
    # IFS=";" read -r -a names <<< "$(echo "${names[@]}" | tr ';' '\n' | sort -u | tr '\n' ';')"
    # IFS is used to
done

# IFS=";" read -r -a names <<< "$(echo "${names[@]}" | tr ';' '\n' | sort -u | tr '\n' ';')"

for name in "${names[@]}"
do
    echo $name >> tempmain.csv
done

sed -i -E 's/^ *//g' tempmain.csv #remove leading spaces
sed -i -E 's/ *$//g' tempmain.csv #remove succedding spaces
sed -i -E '/^$/d' tempmain.csv #remove empty lines
awk '!seen[$0]++' tempmain.csv > tmp && mv tmp tempmain.csv #remove duplicate records

filenum=${#files[@]}
echo $filenum

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
    filename=(${file//./ }) #file name without the extension
    awk -v exam=$filename 'BEGIN{
        FS=","
        OFS=","
    }
    {
        if (NR==1)
        {
            for(i=1;i<=NF;i++)
            {
                if ($i==exam)
                {
                    
                }
            }
        }
    }' $file
done