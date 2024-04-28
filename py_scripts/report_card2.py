from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import csv
from scipy import stats
from percentile import percentiles
from stat_functions import max_marks
from grade import decide_perc
from grade import decide_rubrics
from grade import enter_grades
from grade import decide_grade

def generate_report_card(name,roll_no,exams,student_marks,max_marks_list,grade,all):
    img = Image.open('report_template2.png')

    I1 = ImageDraw.Draw(img)

    myFont = ImageFont.truetype('./regular_font.ttf', 55)
    
    I1.text((500, 430), f"{name}", font=myFont, fill =(0, 0, 0))
    I1.text((320, 550), f"{roll_no}", font=myFont, fill =(0, 0, 0))
    I1.text((1000, 550), f"{grade}", font=myFont, fill =(0, 0, 0))
    
    x=300
    y=850
    for i in range(len(exams)):
        I1.text((x, y), f"{exams[i]}", font=myFont, fill =(0, 0, 0))
        I1.text((x+420, y), f"{student_marks[i]}", font=myFont, fill =(0, 0, 0))
        I1.text((x+700, y), f"{max_marks_list[i]}", font=myFont, fill =(0, 0, 0))
        y+=100

    if all:
        img.save(f"./report_cards/{roll_no}.png")
    else:
        img.show()

all_report_cards=True
user_choice=input('Enter the roll no. to generate report card or enter "all" to generate all report cards: ')
if user_choice!="all":
    all_report_cards=False
student_weighted_perc=[]
grades=enter_grades()
rubrics=decide_rubrics(grades)

with open("./main.csv", mode ='r') as csv_file:
    marks = csv.reader(csv_file,delimiter=',')
    exams=[]
    max=[]
    last=0

    for row in marks:
        name=row[1]
        roll_no=row[0]
        if marks.line_num==1:
            if row[-1]=="Total":
                last=len(row)-1
                for i in range(2,len(row)-1):
                    exams.append(row[i])
                    exam=exams[-1]
                    max.append(max_marks(f"{exam}.csv"))
            else:
                last=len(row)
                for i in range(2,len(row)):
                    exams.append(row[i])
                    exam=exams[-1]
                    max.append(max_marks(f"{exam}.csv"))
        else:
            student_marks=[]
            for i in range(2,last):
                if row[i]=="a":
                    student_marks.append("Absent")
                else:
                    student_marks.append(float(row[i]))

            old_perc_list=percentiles(roll_no)
            percentiles_list=[]
            old_perc_dict=dict(old_perc_list)

            for exam in exams:
                filename=exam+".csv"
                percentile = old_perc_dict[filename]
                if percentile=="Absent":
                    percentiles_list.append("Absent")
                else:
                    percentiles_list.append(percentile.round(2))

            weighted_perc=decide_perc(student_marks,max,rubrics,grades)
            student_weighted_perc.append(weighted_perc)
   

with open("./main.csv", mode ='r') as csv_file:
    marks = csv.reader(csv_file,delimiter=',')
    exams=[]
    max=[]
    last=0

    for row in marks:
        name=row[1]
        roll_no=row[0]
        if marks.line_num==1:
            if row[-1]=="Total":
                last=len(row)-1
                for i in range(2,len(row)-1):
                    exams.append(row[i])
                    exam=exams[-1]
                    max.append(max_marks(f"{exam}.csv"))
            else:
                last=len(row)
                for i in range(2,len(row)):
                    exams.append(row[i])
                    exam=exams[-1]
                    max.append(max_marks(f"{exam}.csv"))
        else:
            student_marks=[]
            for i in range(2,last):
                if row[i]=="a":
                    student_marks.append("Absent")
                else:
                    student_marks.append(float(row[i]))

            old_perc_list=percentiles(roll_no)
            percentiles_list=[]
            old_perc_dict=dict(old_perc_list)

            for exam in exams:
                filename=exam+".csv"
                percentile = old_perc_dict[filename]
                if percentile=="Absent":
                    percentiles_list.append("Absent")
                else:
                    percentiles_list.append(percentile.round(2))
            
            weighted_perc=student_weighted_perc[marks.line_num-2]
            student_percentile=stats.percentileofscore(student_weighted_perc, float(weighted_perc))

            grade=decide_grade(student_percentile,rubrics,grades)
            if all_report_cards:
                generate_report_card(name,roll_no,exams,student_marks,max,grade,all=True)
            else:
                if user_choice==roll_no:
                    generate_report_card(name,roll_no,exams,student_marks,max,grade,all=False)

