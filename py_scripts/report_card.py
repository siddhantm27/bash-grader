from PIL import Image
from PIL import ImageDraw
from PIL import ImageFont
import csv
from grade import percentiles

def generate_report_card(name,roll_no,exams,student_marks,percentiles_list):
    img = Image.open('report_template.png')

    I1 = ImageDraw.Draw(img)

    myFont = ImageFont.truetype('./regular_font.ttf', 55)
    
    # Add Text to an image
    I1.text((500, 430), f"{name}", font=myFont, fill =(0, 0, 0))
    I1.text((320, 550), f"{roll_no}", font=myFont, fill =(0, 0, 0))
    x=300
    y=850
    for i in range(len(exams)):
        I1.text((x, y), f"{exams[i]}", font=myFont, fill =(0, 0, 0))
        I1.text((x+420, y), f"{student_marks[i]}", font=myFont, fill =(0, 0, 0))
        I1.text((x+700, y), f"{percentiles_list[i]}", font=myFont, fill =(0, 0, 0))
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
                exams.append(row[i])
        else:
            student_marks=[]
            for i in range(2,len(row)):
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
                    
            # if roll_no=="23B0942":
            #     print(old_perc_dict)
            #     print(exams)
            #     print(percentiles_list)
            
            generate_report_card(name,roll_no,exams,student_marks,percentiles_list)
    

# generate_report_card("John Doe","1234",["Maths","Science","English"],[90,80,70])