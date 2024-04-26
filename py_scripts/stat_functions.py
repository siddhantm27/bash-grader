import csv 
import statistics

def all_marks(file):
    with open(file, mode ='r') as csv_file:    
        marks = csv.reader(csv_file,delimiter=',')
        marks_list=[]
        totaled_before=False
        for row in marks:
            if marks.line_num==1:
                if row[-1]=="Total":
                    totaled_before=True
            elif marks.line_num!=1 and not totaled_before:
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
            elif totaled_before:
                marks_list.append(float(row[-1]))

        return marks_list
    
def mean(file):
    return statistics.mean(all_marks(file))

def median(file):
    return statistics.median(all_marks(file))

def stdev(file):
    return statistics.stdev(all_marks(file))

def mode(file):
    return statistics.mode(all_marks(file))

def percentile25(file):
    marks=all_marks(file)
    marks.sort()
    return marks[int(len(marks)/4)]

def percentile75(file):
    marks=all_marks(file)
    marks.sort()
    return marks[int(3*len(marks)/4)]

def percentile90(file):
    marks=all_marks(file)
    marks.sort()
    return marks[int(9*len(marks)/10)]

def max_marks(file):
    return max(all_marks(file))

