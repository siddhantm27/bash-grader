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
            if(tolower($i)==tolower(exam))
            {
                field=i
            }
        }
        print $0
    }
    else{
        if(tolower($1)==tolower(roll) || tolower($1)==tolower(name))
    {
        $field=marks
        print $0
    }
    else
    {
        print $0
    }
    }
}