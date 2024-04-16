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
            if($i==exam)
            {
                field=i
            }
        }
        print $0
    }
    else{
        if($1==roll || $1==name)
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