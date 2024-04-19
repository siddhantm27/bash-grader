import os
from stat_functions import mean
from stat_functions import median
from stat_functions import stdev
from stat_functions import mode

print("Enter the option number for the operation you want to perform")
print("1(Mean)\n2(Median)\n3(Standard deviation)\n4(Mode)")
option=input("Enter your option: ")
if option=="1":
    exam=input('Enter the exam name or "main" for the cumulative mean :')
    file=os.path.join(exam+".csv")
    print(f"Mean score: {mean(file)}")
elif option=="2":
    exam=input('Enter the exam name or "main" for the cumulative median :')
    file=os.path.join(exam+".csv")
    print(f"Median score: {median(file)}")
elif option=="3":
    exam=input('Enter the exam name or "main" for the cumulative standard deviation :')
    file=os.path.join(exam+".csv")
    print(f"Standard deviation: {stdev(file)}")
elif option=="4":
    exam=input('Enter the exam name or "main" for the cumulative mode :')
    file=os.path.join(exam+".csv")
    print(f"Mode: {mode(file)}")
else:
    print("Invalid option. Please enter a valid option.")