#!/bin/bash

files=(*.csv)         #creates an array of all csv files in the current in the current directory
temp=()              #creates an empty array

#iterates over the files array and adds all csv files other than main.csv,tempmain.csv and temptempmain.csv to the temp array
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

#contructs the first two headers writes it to a temporary file tempmain.csv
echo -n "Roll_Number,Name" > tempmain.csv

#iterates over the files array and adds the name of the file without the extension i.e. the exam name to the column header of the tempmain.csv file
for file in ${files[@]} 
do  
    tempfile=(${file//./ })
    echo -n ",${tempfile[0]}" >> tempmain.csv
done

echo "" >> tempmain.csv #adds a newline character to the tempmain.csv file

#creates an empty array names
names=()

#iterates over the files array and adds the roll number and name of the student to the names array, where each element is of the form "roll number,name;"
for file in ${files[@]}
do  
    #sets the internal field seperator to ";" from the default field seperator which is " ". This is done to get the whole name, as the name can also have a space in it.
    #not setting the IFS to ";" would cause the awk command to split the name into two different elements of the array
    IFS=";"
    #reads the roll number and name of the student, comma seperated, from the file and stores it in the name variable, 
    name=("$(awk 'BEGIN{FS=",";OFS=","}NR>1{print $1 OFS $2 ";"}' $file)")
    names+=("$name")
done

#iterates over the names array and writes the roll number and name of the student to the tempmain.csv file
for name in "${names[@]}"
do
    echo $name >> tempmain.csv
done

# -i option in sed is used to edit the file in place
#-E option in sed is used to enable extended regular expressions

sed -i -E 's/^ *//g' tempmain.csv #remove leading spaces
sed -i -E 's/ *$//g' tempmain.csv #remove succedding spaces
sed -i -E '/^$/d' tempmain.csv #remove empty lines
awk '!seen[$0]++' tempmain.csv > tmp && mv tmp tempmain.csv #remove duplicate records, thereby keeping only unique records as a student can appear in multiple exams

#creates a variable filenum and assigns the number of elements in the files array to it
filenum=${#files[@]}

#creates a mesh of 'a' characters in tempmain.csv file such that there is a in every column in tempmain.csv for every record
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

#iterates over all csv files and updates the 'a' in the tempmain.csv file with the marks of the student in the respective exam, wherever found
for file in ${files[@]}
do  
    sed -i -E '/^$/d' $file #remove empty lines
    #reads through all lines and calls the combine.awk script for each line
    while IFS="," read -r roll_no name marks
    do  
        examname="${file%.*}" #removes the extension of the file
        #calles the combine.awk script on tempmain.csv, by passing rollno, the examname and marks in that exam to the awk file and stores the output in a temp file
        awk -v roll=$roll_no -v marks=$marks -v exam=$examname -f combine.awk tempmain.csv > temp && mv temp tempmain.csv
    done < <(tail -n +2 $file)
done

#renames the tempmain.csv file to main.csv
sort -t, -k 1 -n tempmain.csv > main.csv
# mv tempmain.csv main.csv
