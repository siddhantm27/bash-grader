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

# for file in ${files[@]}
# do  
#     #remove extension from the file to get the file name
#     filename="${file%.*}"
#     # echo $file
#     # tempname=(${file//./ }) #file name without the extension
#     # echo ${tempname[0]}
#     awk -v exam=$filename '
#     BEGIN{
#         FS=","
#         OFS=","
#         print exam
#     }
#     NR==FNR
#     {
#         if (NR!=1)
#         {
#             marks[$1]=$3
#         }
#     }
#     NR!=FNR
#     {   
#         if (NR==1)
#         {
#             for(i=1;i<=NF;i++)
#             {
#                 if(exam==$i)
#                 {
#                     field=i
#                 }
#             }
#         }
#         else
#         {
#             if($1 in marks)
#             {
#                 for(j=1;j<=NF;j++)
#                 {
#                     if(j==1)
#                     {
#                         printf OFS "here --->" marks[$1]
#                     }
#                     else
#                     {
#                         printf OFS $j  
#                     }
#                 }
#             }
#             printf "\n"
#         }
#     }' $file tempmain.csv >  temptempmain.csv
# done
# fileno=1
# for file in ${files[@]}
# do  
#  echo new file $file $fileno
#     while IFS="," read -r roll_no name marks
#     do  
#         lineno=1
#         echo $roll_no :-
#         while IFS="," read -r roll_no_main name_main all_marks  
#         do  
#         # echo new line $lineno
#             echo $roll_no_main 
#             if [[ $roll_no == $roll_no_main ]]
#             then
#                 # echo " "$marks
#                 sed -i -E "$lineno s/,a,/,$marks,/$fileno" tempmain.csv
#                 break
#             fi
#             let lineno=lineno+1
#         done < <(tail -n +2 tempmain.csv)
#     done < <(tail -n +2 $file)
#     let fileno=fileno+1
# done

# awk '{
#     $1=2
#     system("echo $1")
# }'

# for file in ${files[@]}
# do  
#     while IFS="," read -r roll_no name marks
#     do  
#         awk -v roll=$roll_no -v marks=$marks -v exam=$file 'BEGIN{
#             FS=","
#             OFS=","
#         }
#         {
#             if (NR==1)
#             {   
#                 for(i=1;i<=NF;i++)
#                 {   
#                     if($i==exam)
#                     {   
#                         print i
#                         field=i
#                     }
#                 }
#                 print $0
#             }
#             else
#             {   
#                 if ($1==roll)
#                 {  
#                     for(j=1;j<=NF;j++)
#                     {
#                         if(j==field)
#                         {
#                             printf "," marks
#                         }
#                         else
#                         {
#                             printf "," $j
#                         }
#                     }
#                 }
#             }
#         }' tempmain.csv
#     done < <(tail -n +2 $file)
# done
for file in ${files[@]}
do  
    sed -i -E '/^$/d' $file #remove empty lines
    while IFS="," read -r roll_no name marks
    do  
        filename="${file%.*}"
        # echo hi $roll_no
        # if [[ "$roll_no" == "22B009" ]]
        # then
        #     echo "*************"
        #     echo $roll_no
        #     echo $name
        #     echo $marks
        #     echo $filename
        #     echo "*************"
        #     echo "###########################"
        #     echo $roll_no 
        #     echo "###########################"
        # fi
        awk -v roll=$roll_no -v marks=$marks -v exam=$filename 'BEGIN{
            FS=","
            OFS=","
            field=0
        }
        {
            if (NR==1)
            {   
                for(i=1;i<=NF;i++)
                {   
                    if($i==exam)
                    {   
                        field=i
                    }
                }
                print $0
            }
            else
            {   
                if ($1==roll)
                {  
                    # print $1 " " roll
                    printf $1 OFS $2
                    for(j=3;j<=NF;j++)
                    {
                        if(j==field)
                        {   
                            # print "--->" j " " field
                            printf "," marks
                        }
                        else
                        {
                            printf "," $j
                        }
                    }
                    printf "\n"
                }
                else
                {
                    print $0
                }
            }
        }' tempmain.csv > temp && mv temp tempmain.csv
    done < <(tail -n +2 $file)
done