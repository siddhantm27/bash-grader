BEGIN {
    FS = ","
    OFS = ","
}

{
    if (NR == 1) { print $0 }
    else {
        #checks the if the roll number of the record matches the roll number given by the user (both lower case)
        if (tolower($1) == tolower(roll)) {
            #marks are updated to the new marks given by the user and printed
            $3 = marks
            print $0
        }
        else { print $0 }
    }
}
