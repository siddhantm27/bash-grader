import os
from graph_functions import histogram
from graph_functions import scatter_plot

option=input("Enter the option number for the graph you want to plot: ")

if option=="1":
    exam=input('Enter the exam name or "main" for the plot :')
    file=os.path.join(exam+".csv")
    histogram(file)
elif option=="2":
    exam=input('Enter the exam name or "main" for the plot :')
    file=os.path.join(exam+".csv")
    scatter_plot(file)

    