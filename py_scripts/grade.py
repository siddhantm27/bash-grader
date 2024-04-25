import os
import csv
from scipy import stats

# print("1 : Manual Grading")
# print("2 : Auto Grading")
# user_choice=input("Enter your choice: ")

def decide_rubrics():
    rubrics=[]
    print("Enter your rubrics for grading")
    more_grades=True
    grades=["AP","AA","AB","BB","BC","CC","CD","DD"]
    for grade in grades:
        continue_to_next_grade=False
        while not continue_to_next_grade:
            range=input(f'Enter the percentile range for {grade} in the format "<upper>-<lower>"": ')
            range=range.split("-")
            if len(rubrics)>0:
                if int(range[0])==int(rubrics[-1][1]):
                    rubrics.append(range)
                    continue_to_next_grade=True
                else:
                    print("Please enter valid range")                  
            else:
                rubrics.append(range)
                continue_to_next_grade=True
    grades.append("F")
    rubrics.append([rubrics[-1][1],0])
    return rubrics

def all_marks(file):
    with open(file, mode ='r') as csv_file:    
        marks = csv.reader(csv_file,delimiter=',')
        marks_list=[]
        for row in marks:
            if marks.line_num!=1:
                if row[2]=="a":
                    mark=0
                else:
                    mark=row[2]
                marks_list.append(float(mark))
        return marks_list

def get_marks(roll_no,file):
    with open(file, mode ='r') as csv_file:    
        marks = csv.reader(csv_file,delimiter=',')
        for row in marks:
            if row[0]==roll_no:
                return row[2]
        return 0

def percentiles(roll_no):

    dirname = './'
    ext = 'csv'
    perc=[]

    for files in os.listdir(dirname):
        if files.endswith(ext) and files!='main.csv':
            marklist=all_marks(files)
            student_marks=get_marks(roll_no,files)
            if student_marks!=0:
                percentile = stats.percentileofscore(marklist, float(student_marks))
                perc.append([files,percentile])
            else:
                perc.append([files,"Absent"])
    return perc
