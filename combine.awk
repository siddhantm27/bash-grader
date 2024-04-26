BEGIN {
    FS = ","
    OFS = ","
    field = 0
}

{   
    #sets the field as the column number of exam name
    if (NR == 1) {
        for (i = 1; i <= NF; i++) {
            if ($i == exam) { field = i }
        }

        print $0
    }
    else {
        #checks if the roll number matches the given roll number
        if ($1 == roll) {
            printf($1 OFS $2)
            #iterates through all columsn of tempmain.csv, printing each value till it the finds the field, where it replaces the value with the marks passed down as a variable when calling combine.awk
            for (j = 3; j <= NF; j++) {
                if (j == field) {
                    printf("," marks)
                }
                else { printf("," $j) }
            }

            printf("\n")
        }
        #or else prints the whole line as it is
        else { print $0 }
    }
}