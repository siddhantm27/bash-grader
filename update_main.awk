BEGIN{
    FS=","
    OFS=","
    field=0
}
{   
    if(NR==1)
    {
        for(i=1;i<=NF;i++)
        {   
            #sets the field number to the exam column passed by the user
            if(tolower($i)==tolower(exam))
            {
                field=i
            }
        }
        print $0
    }
    else{
        #checks if the roll number and name matches the user input
        if(tolower($1)==tolower(roll) || tolower($1)==tolower(name))
    {   
        #if matched, marks are updated to the user input
        $field=marks
        print $0
    }
    else
    {
        print $0
    }
    }
}