BEGIN {
    FS = ","
    OFS = ","
}

{
    # function newcol()
    
        if (NR == 1) { print $0 }
        else { print $0, "a" }
    
    # newcol()
}
