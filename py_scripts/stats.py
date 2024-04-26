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

print(f"Mean score: {mean(file)}")
print(f"Median score: {median(file)}")
print(f"Standard deviation: {stdev(file)}")
print(f"Mode: {mode(file)}")
print(f"marks for 25th Percentile: {percentile25(file)}")
print(f"Marks for 75th Percentile: {percentile75(file)}")
print(f"Marks for 90th Percentile: {percentile90(file)}")
print(f"Maximum marks: {max_marks(file)}")
