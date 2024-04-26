from stat_functions import max_marks

def enter_grades():
    grades=input("Enter grades in descending order (comma-seperated)")
    grades=grades.split(",")
    print(len(grades))
    return grades

def decide_rubrics(grades):
    rubrics=[]
    print("Enter your rubrics for grading")
    more_grades=True
    for grade in grades:
        continue_to_next_grade=False
        while not continue_to_next_grade:
            range=input(f'Enter the percentage range for {grade} in the format "<upper>-<lower>"": ')
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
    return rubrics

def decide_grade(student_marks,max_marks,rubrics,grades):
    weighted_sum=0
    total_max_marks=0
    for i in range(len(student_marks)):
        if student_marks[i]!="Absent":
            weighted_sum+=float(student_marks[i])*float(max_marks[i])
            total_max_marks+=float(max_marks[i])*float(max_marks[i])
    weighted_perc=(weighted_sum/total_max_marks)*100
    for i in range(len(rubrics)):
        if weighted_perc<=int(rubrics[i][0]) and weighted_perc>int(rubrics[i][1]):
            return grades[i]

