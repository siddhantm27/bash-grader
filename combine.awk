BEGIN {
    FS = ","
    OFS = ","
    field = 0
}

{
    if (NR == 1) {
        for (i = 1; i <= NF; i++) {
            if ($i == exam) { field = i }
        }

        print $0
    }
    else {
        if ($1 == roll) {
            # print $1 " " roll
            printf($1 OFS $2)

            for (j = 3; j <= NF; j++) {
                if (j == field) {
                    # print "--->" j " " field
                    printf("," marks)
                }
                else { printf("," $j) }
            }

            printf("\n")
        }
        else { print $0 }
    }
}
