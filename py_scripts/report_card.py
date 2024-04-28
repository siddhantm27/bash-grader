from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import csv
import os
from scipy import stats
from stat_functions import max_marks
from grade import decide_perc
from grade import decide_rubrics
from grade import enter_grades
from grade import decide_grade

def generate_report_card(name,roll_no,exams,student_marks,max_marks_list,grade,all):
    img = Image.open('report_template.png') #opens the template file

    I1 = ImageDraw.Draw(img) #draws the image

    myFont = ImageFont.truetype('./regular_font.ttf', 55) #sets the font and size from the ttf file
    
    I1.text((500, 430), f"{name}", font=myFont, fill =(0, 0, 0)) #writes the name on the image
    I1.text((320, 550), f"{roll_no}", font=myFont, fill =(0, 0, 0)) #writes the roll no. on the image
    I1.text((1000, 550), f"{grade}", font=myFont, fill =(0, 0, 0)) #writes the grade on the image
    
    x=300 
    y=850
    #iterates over all exams and writes the exam name, student marks and max marks on the image, by changing the values of x and y
    for i in range(len(exams)):
        I1.text((x, y), f"{exams[i]}", font=myFont, fill =(0, 0, 0)) #writes the exam name on the image
        I1.text((x+420, y), f"{student_marks[i]}", font=myFont, fill =(0, 0, 0)) #writes the student marks on the image
        I1.text((x+700, y), f"{max_marks_list[i]}", font=myFont, fill =(0, 0, 0)) #writes the max marks on the image
        y+=100 # to move to the next line

    #if the user wants to generate all report cards, the image is saved as a png and then converted to pdf, using the PIL library
    if all:
        img.save(f"./report_cards/{roll_no}.png")
        image_1 = Image.open(f"./report_cards/{roll_no}.png")
        im_1 = image_1.convert('RGB')
        im_1.save(f"./report_cards/{roll_no}.pdf")
        os.remove(f"./report_cards/{roll_no}.png")
        
    #if the user wants to generate a specific report card, the image is just displayed
    else:
        img.show()
        



all_report_cards=True
#if the user wants to generate a specific report card, the user is asked to enter the roll no. of the student or if they want the report cards of all students
user_choice=input('Enter the roll no. to generate report card or enter "all" to generate all report cards: ')
if user_choice!="all":
    all_report_cards=False
    
students_weighted_perc=[] #list to store the weighted percentage of all students
grades=enter_grades() #function to enter the grades from the instructors
rubrics=decide_rubrics(grades) #gets the rubrics from the instructor, based on the grades given earlier

exams=[] #gets the list of all exams conducted i.e. whose csv files are in the current directory
max=[] #stores the maximum scores in all these exams in order of the exams list

all_student_marks=[] #list to store the marks of all students

#reads the csv file
with open("./main.csv", mode ='r') as csv_file:
    marks = csv.reader(csv_file,delimiter=',')

    #iterates over all rows in the csv file
    for row in marks:
        name=row[1]
        roll_no=row[0]
        #it gets the exam names and max marks for each exam from the first row of the csv file and also checks if the file was totaled before or not 
        if marks.line_num==1:
            for i in range(2,len(row)):
                exams.append(row[i])
                exam=exams[-1]
                max.append(max_marks(f"{exam}.csv")) #max_marks function returns the maximum score in a particular exam
        else:
            student_marks=[] #list to store the marks of the student
            for i in range(2,len(row)):
                if row[i]=="a":
                    student_marks.append("Absent")
                else:
                    student_marks.append(float(row[i]))
            all_student_marks.append(student_marks) #appends the marks of the student to the list of all students' marks

            weighted_perc=decide_perc(student_marks,max) #function to calculate the weighted percentage of the student
            students_weighted_perc.append(weighted_perc) #appends the weighted percentage of the student to the list
   
#now we have a list of weighted percentages of all students, we can now calculate their percentile and grade

#iterates over all rows in the csv file
with open("./main.csv", mode ='r') as csv_file:
    marks = csv.reader(csv_file,delimiter=',')

    for row in marks:
        name=row[1]
        roll_no=row[0]
        if marks.line_num!=1:
            #gets the marks of the student and the weighted percentage of the student
            student_marks=all_student_marks[marks.line_num-2]
            weighted_perc=students_weighted_perc[marks.line_num-2]

            #calculates the percentile of the student based on the weighted percentage using the stats function from the scipy library
            student_percentile=stats.percentileofscore(students_weighted_perc, float(weighted_perc))

            #gets the grade from the decide_grade function based on the rubrics given in decide_rubrics
            grade=decide_grade(student_percentile,rubrics,grades)

            if all_report_cards: #if the user wants to generate all report cards
                generate_report_card(name,roll_no,exams,student_marks,max,grade,all=True)
            else:
                if user_choice==roll_no: #if the user wants to generate a specific report card
                    generate_report_card(name,roll_no,exams,student_marks,max,grade,all=False)

print("Report card/s generated successfully")

