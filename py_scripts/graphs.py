import os
from graph_functions import histogram
from graph_functions import scatter_plot

option=input("Enter the option number for the graph you want to plot:\n1)Histogram\n2)Scatter Plot\n")

if option=="1":
    exam=input('Enter the exam name or "main" for the plot :')
    file=os.path.join(exam+".csv")
    if not os.path.exists(file):
        print(f"{file} does not exist")
        exit()
    histogram(file)
elif option=="2":
    exam=input('Enter the exam name or "main" for the plot :')
    file=os.path.join(exam+".csv")
    if not os.path.exists(file):
        print(f"{file} does not exist")
        exit()
    scatter_plot(file)

    