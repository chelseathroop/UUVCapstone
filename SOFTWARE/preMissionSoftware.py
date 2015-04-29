from Tkinter import *
from tkFileDialog import *


root = Tk()

i = 3
index = 0

dataArray = []


programGreet = Label(root, text = 'Welcome to the Acoustic Recording Device Center')
programGreet.grid(row = 0, columnspan = 10)


# Add new line of data parameters when button is pressed and print the contents of the entries
def newLineEnter() :
    global i
    i = i + 1
    global index
    index = index + 6
    

  
    dataArray.append(Entry(root, width = 5))
    dataArray[index].grid(row = (i-1), column = 1) 
    dataArray.append(Entry(root, width = 5))
    dataArray[index+1].grid(row = (i-1), column = 2)
    dataArray.append(Entry(root, width = 5))
    dataArray[index+2].grid(row = (i-1), column = 3)
        

    dataArray.append(Entry(root, width = 10))
    dataArray[(index + 3)].grid(row = (i-1), column = 5) 
        

    dataArray.append(Entry(root, width = 10))
    dataArray[(index + 4)].grid(row = (i-1), column = 7) 

    dataArray.append(Entry(root, width = 10))
    dataArray[(index + 5)].grid(row = (i-1), column = 9) 


    # Move buttons down
    saveParam.grid(row = i, column = 5)
 
    newLine.grid(row = i, column = 6)

def saveParameters() :
    dataFile =  asksaveasfile(initialfile = 'dataFile.txt', initialdir = 'chelseathroop/Documents/ECE/Capstone')
    for k in dataArray:
        dataFile.write(k.get()) 
        dataFile.write(',') 
       
        




# Prompt user for first date
Label(root, text = "Date (YYMMDD) : ").grid(row = 2, column = 0)
dataArray.append(Entry(root, width = 5))
dataArray[0].grid(row = 2, column = 1) 

dataArray.append(Entry(root, width = 5))
dataArray[1].grid(row = 2, column = 2) 

dataArray.append(Entry(root, width = 5))
dataArray[2].grid(row = 2, column = 3) 



# Prompt user for first start time
Label(root, text = "Start Time : ").grid(row = 2, column = 4)
dataArray.append(Entry(root, width = 10))
dataArray[3].grid(row = 2, column = 5)


# Prompt user for first End Time
Label(root, text = "End Time : ").grid(row = 2, column = 6)
dataArray.append(Entry(root, width = 10))
dataArray[4].grid(row = 2, column = 7)


# Prompt user for Sample Rate
Label(root, text = "Sample Rate (kHz) : ").grid(row = 2, column = 8)
dataArray.append(Entry(root, width = 10))
dataArray[5].grid(row = 2, column = 9)







# Save Parameter button
  
saveParam = Button(root, text = 'Save Parameters', command = saveParameters)
saveParam.grid(row = i, column = 5)
  
# Enter new line of paramters
 
newLine = Button(root, text = 'Enter New Line', command = newLineEnter)
newLine.grid(row = i, column = 6)




root.title('UUV Record Program')
root.mainloop()



