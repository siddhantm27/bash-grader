BEGIN {
    FS = ","
    OFS = ","
}

{
    if (NR == 1) { print $0 }
    else {
        if (tolower($1) == tolower(roll)) {
            $3 = marks
            print $0
        }
        else { print $0 }
    }
}
