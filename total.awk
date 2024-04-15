BEGIN{
    FS=","
    OFS=","
    totaled_before="false"
}
{
    if (NR==1)
    {
        if ($NF=="Total")
        {   
            totaled_before="true"
            print $0
        }
        else
        {   
            
            print $0 OFS "Total"
        }
    }
    else
    {   
        total=0
        if (totaled_before=="true")
        {   
            printf $1 OFS $2 OFS
            for(record_no=3;record_no<NF;record_no++)
            {
                printf $record_no OFS
                if ($record_no=="a")
                {
                    total+=0
                }
                else
                {
                    total+=$record_no
                }
            }
            print total
        }
        else
        {   
            for(record_no=3;record_no<=NF;record_no++)
            {
                if ($record_no=="a")
                {
                    total+=0
                }
                else
                {
                    total+=$record_no
                }
            }
            print $0 OFS total
        }
    }
}