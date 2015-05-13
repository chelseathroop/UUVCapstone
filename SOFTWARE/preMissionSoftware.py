
from Tkinter import *
from tkFileDialog import *



root = Tk()


i = 3
index = 0

dataArray = []
arrayOfArrays = []

programGreet = Label(root, text = 'Welcome to the Acoustic Recording Device Center')
programGreet.grid(row = 0, columnspan = 9)


# Add new line of data parameters when button is pressed and print the contents of the entries
def newLineEnter() :
    global i
    i = i + 2
    global index
    index = index + 8
    

  
    Label(root, text = "Date (YYMMDD) : ").grid(row = (i-1), column = 0)

    dataArray.append(Entry(root, width = 5))            # Year entry
    dataArray[index].grid(row = (i-1), column = 1) 
    dataArray.append(Entry(root, width = 5))            # Month entry
    dataArray[index+1].grid(row = (i-1), column = 2)    
    dataArray.append(Entry(root, width = 5))
    dataArray[index+2].grid(row = (i-1), column = 3)    # Day entry
        

    Label(root, text = "Start Time (HHMM) : ").grid(row = (i-1), column = 4)
    dataArray.append(Entry(root, width = 5))           # Start time entry
    dataArray[(index + 3)].grid(row = (i-1), column = 5)
    dataArray.append(Entry(root, width = 5))
    dataArray[(index + 4)].grid(row = (i-1), column = 6) 
        
    
    Label(root, text = "End Time (HHMM) : ").grid(row = i, column = 4)
    dataArray.append(Entry(root, width = 5))           # End time entry
    dataArray[(index + 5)].grid(row = (i), column = 5)
    dataArray.append(Entry(root, width = 5)) 
    dataArray[(index + 6)].grid(row = (i), column = 6)

    Label(root, text = "Sample Rate (kHz) : ").grid(row = (i-1), column = 7)
    dataArray.append(Entry(root, width = 10))           # Sample rate entry
    dataArray[(index + 7)].grid(row = (i-1), column = 8) 

    # Create Array of Arrays
    arrayOfArrays.append([dataArray[index-8].get(),dataArray[index-7].get(),dataArray[index-6].get(),dataArray[index-5].get(),dataArray[index-4].get(),dataArray[index-3].get(), dataArray[index-2].get(), dataArray[index-1].get()])
    
    # Move buttons down
    saveParam.grid(row = (i+1), column = 7)
 
    newLine.grid(row = (i+1), column = 8)

def saveParameters() :
    dataFile =  asksaveasfile(initialfile = 'dataFile.txt', initialdir = 'chelseathroop/Documents/ECE/Capstone')
    
    arrayOfArrays.append([dataArray[index].get(),dataArray[index+1].get(),dataArray[index+2].get(),dataArray[index+3].get(),dataArray[index+4].get(),dataArray[index+5].get(),dataArray[index+6].get(),dataArray[index+7].get()])

    dataFile.write('{ ')    
    for array in arrayOfArrays:
        time = 3
        for x in range(2):
            dataFile.write('{')
            for k in range(3):
                dataFile.write(array[k]) 
                dataFile.write(',')
            dataFile.write(array[time])
            dataFile.write(',')
            dataFile.write(array[time+1])
            dataFile.write(',')
            dataFile.write(array[k+5]) 
            dataFile.write('}\n')
            time = time +2
    dataFile.write(' }')
       



# Prompt user for first date
Label(root, text = "Date (YYMMDD) : ").grid(row = 2, column = 0)
dataArray.append(Entry(root, width = 5))
dataArray[0].grid(row = 2, column = 1) 

dataArray.append(Entry(root, width = 5))
dataArray[1].grid(row = 2, column = 2) 

dataArray.append(Entry(root, width = 5))
dataArray[2].grid(row = 2, column = 3) 



# Prompt user for first start time
Label(root, text = "Start Time (HHMM) : ").grid(row = 2, column = 4)
dataArray.append(Entry(root, width = 5))
dataArray[3].grid(row = 2, column = 5)
dataArray.append(Entry(root, width = 5))
dataArray[4].grid(row = 2, column = 6)


# Prompt user for first End Time
Label(root, text = "End Time : ").grid(row = 3, column = 4)
dataArray.append(Entry(root, width = 5))
dataArray[5].grid(row = 3, column = 5)
dataArray.append(Entry(root, width = 5))
dataArray[6].grid(row = 3, column = 6)


# Prompt user for Sample Rate
Label(root, text = "Sample Rate (kHz) : ").grid(row = 2, column = 7)
dataArray.append(Entry(root, width = 10))
dataArray[7].grid(row = 2, column = 8)


# Save Parameter button
  
saveParam = Button(root, text = 'Save Parameters', command = saveParameters)
saveParam.grid(row = (i+1), column = 7)
  
# Enter new line of paramters
 
newLine = Button(root, text = 'Enter New Line', command = newLineEnter)
newLine.grid(row = (i+1), column = 8)





root.title('UUV Record Program')
root.mainloop()



