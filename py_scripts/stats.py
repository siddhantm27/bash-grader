import os
from stat_functions import mean
from stat_functions import median
from stat_functions import stdev
from stat_functions import mode
from stat_functions import percentile25
from stat_functions import percentile75
from stat_functions import percentile90
from stat_functions import max_marks

exam=input("Enter the exam name : ")
file=os.path.join(exam+".csv")

if not os.path.exists(file):
    print(f"{file} does not exist")
    exit()
print("------------------------------------")
print(f"Statistics for {exam}")
print(f"Mean score: {round(mean(file),2)}")
print(f"Median score: {round(median(file),2)}")
print(f"Mode: {round(mode(file),2)}")
print(f"Standard deviation: {round(stdev(file),2)}")
print(f"marks for 25th Percentile: {percentile25(file)}")
print(f"Marks for 75th Percentile: {percentile75(file)}")
print(f"Marks for 90th Percentile: {percentile90(file)}")
print(f"Maximum marks: {max_marks(file)}")
