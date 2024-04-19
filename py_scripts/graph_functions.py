import matplotlib.pyplot as plt
import csv
from stat_functions import mean, median, stdev, mode, percentile25, percentile75, percentile90

def all_marks(file):
    with open(file, mode ='r') as csv_file:    
        marks = csv.reader(csv_file,delimiter=',')
        marks_list=[]
        for row in marks:
            if marks.line_num!=1:
                if len(row)==3:
                    if row[2]=="a":
                        mark=0
                    else:
                        mark=float(row[2])
                    marks_list.append(mark)
                else:
                    total_marks=0
                    for i in range(2,len(row)):
                        if row[i]=="a":
                            total_marks+=0
                        else:
                            total_marks+=float(row[i])
                    marks_list.append(total_marks)
        return marks_list

def histogram(file):
    exam=file.split(".")[0]
    marklist=all_marks(file)
    marklist.sort(reverse=True)
    mean_marks=mean(file)
    perc_90=percentile90(file)
    perc_75=percentile75(file)
    
    plt.hist(marklist,bins=10,edgecolor='black')
    plt.xlabel('Marks')
    plt.ylabel('Number of students')
    plt.title(f"Histogram of marks in {exam}")
    plt.axvline(x=perc_90, color='green', linestyle='--', label='90th Percentile')
    plt.axvline(x=perc_75, color='orange', linestyle='--', label='75th Percentile')
    plt.axvline(x=mean_marks, color='red', linestyle='--', label='Mean')
    plt.legend()
    plt.show()

def scatter_plot(file):
    exam=file.split(".")[0]
    marklist=all_marks(file)
    marklist.sort(reverse=True)
    mean_marks=mean(file)
    perc_90=percentile90(file)
    perc_75=percentile75(file)

    plt.scatter(range(1,len(marklist)+1),marklist)
    plt.xlabel('Rank')
    plt.ylabel('Marks')
    plt.title(f"Scatter plot of marks in {exam}")
    plt.axhline(y=perc_90, color='green', linestyle='--', label=f'90th Percentile={round(perc_90,2)}')
    plt.axhline(y=perc_75, color='orange', linestyle='--', label=f'75th Percentile={round(perc_75,2)}')
    plt.axhline(y=mean_marks, color='red', linestyle='--', label=f'Mean={round(mean_marks,2)}')
    plt.legend()
    plt.show()
