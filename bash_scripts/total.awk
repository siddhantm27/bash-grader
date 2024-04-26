BEGIN{
    FS=","
    OFS=","
    totaled_before="false" #checks if the file was totaled before
}
{
    if (NR==1)
    {   
        #checks if the header of the last column is "Total"
        if ($NF=="Total") 
        {   
            #if it is, then the totaled_before is set to true
            totaled_before="true" 
            print $0
        }
        else
        {   
            #if it is not, then the file was not totaled before and "Total" is added as the header of the last column
            print $0 OFS "Total" 
        }
    }
    else
    {   
        #total variable is initialized to zero
        total=0
        #if file was totaled before
        if (totaled_before=="true")
        {   
            #the first two columns are printed
            printf $1 OFS $2 OFS
            #the loop goes through the columns from the third to the second last column. The last column has an old total value from the time it was totales previously
            for(record_no=3;record_no<NF;record_no++)
            {   
                #the values of the columns are added to the total and the columns are printed as we go through the loop
                printf $record_no OFS
                if ($record_no=="a")
                {   
                    #if the value is "a", it is treated as zero
                    total+=0
                }
                else
                {
                    total+=$record_no
                }
            }
            #new total is printed in the last column
            print total
        }
        else
        {   
            #if the file was not totaled before, the loop goes through the columns from the third to the last column
            for(record_no=3;record_no<=NF;record_no++)
            {   
                #the values of the columns are added to the total
                if ($record_no=="a")
                {
                    #if the value is "a", it is treated as zero
                    total+=0
                }
                else
                {
                    total+=$record_no
                }
            }
            #the values of the columns are printed and total is printed in the last column
            print $0 OFS total
        }
    }
}