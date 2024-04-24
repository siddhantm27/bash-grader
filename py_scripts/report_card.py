from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import csv

def generate_report_card(name,roll_no,exams,student_marks):
    img = Image.open('report_template.png')

    I1 = ImageDraw.Draw(img)

    myFont = ImageFont.truetype('./regular_font.ttf', 55)
    
    # Add Text to an image
    I1.text((500, 430), f"{name}", font=myFont, fill =(0, 0, 0))
    I1.text((320, 550), f"{roll_no}", font=myFont, fill =(0, 0, 0))
    x=350
    y=850
    for i in range(len(exams)):
        I1.text((x, y), f"{exams[i]}", font=myFont, fill =(0, 0, 0))
        I1.text((x+500, y), f"{student_marks[i]}", font=myFont, fill =(0, 0, 0))
        y+=100
    # Display edited image
    # img.show()
    # Save the edited image
    img.save(f"./report_cards/{roll_no}.png")

with open("./main.csv", mode ='r') as csv_file:
    marks = csv.reader(csv_file,delimiter=',')
    exams=[]
    for row in marks:
        name=row[1]
        roll_no=row[0]
        if marks.line_num==1:
            for i in range(2,len(row)):
                exams.append(row[i].capitalize())
        else:
            student_marks=[]
            for i in range(2,len(row)):
                if row[i]=="a":
                    student_marks.append(0)
                else:
                    student_marks.append(float(row[i]))
            generate_report_card(name,roll_no,exams,student_marks)
    

# generate_report_card("John Doe","1234",["Maths","Science","English"],[90,80,70])