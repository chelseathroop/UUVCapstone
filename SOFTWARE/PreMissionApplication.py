
from Tkinter import *
from tkFileDialog import *


i = 3              #  Set up variables for rows and indexing arrays of data
index = 0
time = 0
totalFileSize = 0
SD1 = 0
SD2 = 0
SD3 = 0
SD4 = 0
dataArray = []
arrayOfArrays = []
 
currentInfo = []


class scheduleApp() :
    # Create initial application and call functions
    def __init__(self) :
        self.root = Tk() 
        programGreet = Label(self.root, text = 'Welcome to the Acoustic Recording Device Center', fg = 'blue', font = ('Times New Roman',16))
        programGreet.grid(row = 0, columnspan = 9)
        self.createEntryLine()        
        self.root.title('UUV Acoustic Recording Schedule')
        self.root.mainloop()
   

    # Define callback for entering new line of data   
    def createEntryLine(self) :
        
        # Define function for adding new lines of data entry       
        def newLineEnter() :
            global i
            i = i + 2
            global index
            index = index + 8
      
  
            # Year entry with validation commands
            Label(self.root, text = "Date (YYMMDD) : ").grid(row = (i+1), column = 0)
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = yearvcmd, invalidcommand = yearinval))              
            dataArray[index].grid(row = (i+1), column = 1) 

             # Month entry with validation command
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = monthvcmd, invalidcommand = monthinval))  
            dataArray[index+1].grid(row =(i+1), column = 2)    
            
            # Day entry with validation commands
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = dayvcmd, invalidcommand = dayinval))
            dataArray[index+2].grid(row = (i+1), column = 3) 
          
            # Start time entry hour
            Label(self.root, text = "Start Time - 24hr clock (HHMM) : ").grid(row = (i+1), column = 4)
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = startHourvcmd, invalidcommand = startHourinval))  
            dataArray[(index + 3)].grid(row = (i+1), column = 5)
            
            # Start time entry minute
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = startMinvcmd, invalidcommand = startMininval))
            dataArray[(index + 4)].grid(row = (i+1), column = 6) 
          
            # End time entry hour
            Label(self.root, text = "End Time : ").grid(row = i+2, column = 4)
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = endHourvcmd, invalidcommand = endHourinval))  
            dataArray[(index + 5)].grid(row = (i+2), column = 5)
            
            # End time entry minute
            dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = endMinvcmd, invalidcommand = endMininval)) 
            dataArray[(index + 6)].grid(row = (i+2), column = 6)
            
            # Sample rate entry    
            Label(self.root, text = "Sample Rate 44, 48, 96 (kHz) : ").grid(row = (i+1), column = 7)
            dataArray.append(Entry(self.root, width = 10, validate = 'focusout', validatecommand = samplevcmd, invalidcommand = sampleinval))    
            dataArray[(index + 7)].grid(row = (i+1), column = 8) 
  
            # Create Array of Data Arrays
            arrayOfArrays.append([dataArray[index-8].get(),dataArray[index-7].get(),dataArray[index-6].get(),dataArray[index-5].get(),dataArray[index-4].get(),dataArray[index-3].get(),dataArray[index-2].get(), dataArray[index-1].get()])
      
            
            # Calculate total time and move down
            global time
            subHours = float(dataArray[index-3].get()) - float(dataArray[index-5].get())
            subMins = float(dataArray[index-2].get())- float(dataArray[index-4].get())
            if subMins <0:
                subHours = subHours-1
                subMins = subMins+60
            subMins = subMins/60
            time = round(time+subHours+subMins,2)
            
            # Calculate amount of files on each card
            global totalFileSize   
            global SD1
            global SD2
            global SD3
            global SD4
            timeSec = 3600*time 
            if dataArray[index-1] == 96:
                bits = 24
            else:
                bits = 16
            totalFileSize = totalFileSize + ((timeSec*float(dataArray[index-1].get())*bits*2000)/8)
            print (totalFileSize/1000000000)
            if totalFileSize < 32000000000:
                SD1 = SD1 +1
            elif totalFileSize > 32000000000 and totalFileSize < 64000000000:
                SD2 = SD2 +1
            elif totalFileSize > 64000000000 and totalFileSize < 96000000000:
                SD3 = SD3 +1
            elif totalFileSize > 96000000000 and totalFileSize < 128000000000:
                SD4 = SD4 +1


                    
            #Display total time amount
            if time < 96:
                stringTime = str(time)
            else:
                stringTime = 'Record Time Too Long'
            totalTimeLabel = Label(self.root, text = 'Total Time : ').grid(row = (i+3), column = 4)
            totatDisplay = Label (self.root, text = stringTime).grid(row = (i+3), column = 5)
            # Move buttons down
            saveParam.grid(row = (i+3), column = 7)
        
            newLine.grid(row = (i+3), column = 8)



#############################################################################################################################################
        # Define call back for saving paramters and writing them to the output file
        # SET THIS TO DESIRED FILE PATH AND FILE NAME #
        def saveParameters() :
            dataFile =  asksaveasfile(initialfile = 'dataFile.txt', initialdir = '/Users/chelseathroop/Documents/ECE/Capstone')
##############################################################################################################################################            
           
            # Write all data to text file 
            dataFile.write('//TYPEDEFS\ntypedef uint8_t byte;\ntypedef int8_t sbyte;\n\n')
            dataFile.write('byte alarm_dhms[][6] = { \n')    
            for array in arrayOfArrays:
                time = 3
                for x in range(2):
                    dataFile.write('{')
                    
                    dataFile.write('0x')
                    dataFile.write(array[2]) 
                    dataFile.write(',')
                    dataFile.write('0x')
                    dataFile.write(array[time])
                    dataFile.write(',')
                    dataFile.write('0x')
                    dataFile.write(array[time+1])
                    dataFile.write(',') 
                    dataFile.write('0x00')
                    dataFile.write(',')
                    dataFile.write(array[7]) 
                    dataFile.write(',')
                    dataFile.write(str(x))
                    dataFile.write('},\n')
                    time = time +2
            dataFile.write(' }\n')
            dataFile.write('int const SD1=')
            dataFile.write(str(SD1))
            dataFile.write(';\n')
            
            dataFile.write('int const SD2=')
            dataFile.write(str(SD2))
            dataFile.write(';\n')

            dataFile.write('int const SD3=')
            dataFile.write(str(SD3))
            dataFile.write(';\n')
           
            dataFile.write('int const SD4=')
            dataFile.write(str(SD4))
            dataFile.write(';\n')
            
            #Get all current day/time values
            
            year = currentInfo[0].get()
            month = currentInfo[1].get()
            weekday = currentInfo[3].get()
            day = currentInfo[2].get()
            hour = currentInfo[4].get()
            minute = currentInfo[5].get()

            dataFile.write('// current time : clock[][7] = {second, minute, hour, day, weekday, month, year}\n\n')
            dataFile.write('byte clock[][7] = {0x00,')
            dataFile.write('0x')
            dataFile.write(minute)
            dataFile.write(',')
            dataFile.write('0x')
            dataFile.write(hour)
            dataFile.write(',')
            dataFile.write('0x')
            dataFile.write(day)
            dataFile.write(',')
            dataFile.write('0x')
            dataFile.write(weekday)
            dataFile.write(',')
            dataFile.write('0x')
            dataFile.write(month)
            dataFile.write(',')
            dataFile.write('0x')
            dataFile.write(year)
            dataFile.write('};')



#THIS IS THE MAIN LINE CREATING FIRST LINE OF ENTRY WIDGETS

        # Prompt user for first date and validate all entries
        # YEAR
        Label(self.root, text = " Date (YYMMDD) : ").grid(row = (i+1), column = 0)
        yearvcmd = (self.root.register(self.validateYear), '%P')
        yearinval = (self.root.register(self.invalidYear), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = yearvcmd, invalidcommand = yearinval))
        dataArray[index].grid(row = (i+1), column = 1) 

        # MONTH  
        monthvcmd = (self.root.register(self.validateMonth), '%P')
        monthinval = (self.root.register(self.invalidMonth), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = monthvcmd, invalidcommand = monthinval))
        dataArray[index+1].grid(row = (i+1), column = 2) 
 
        # DAY
        dayvcmd = (self.root.register(self.validateDay), '%P')
        dayinval = (self.root.register(self.invalidDay), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = dayvcmd, invalidcommand = dayinval))
        dataArray[index+2].grid(row = (i+1), column = 3) 
 
 
        # Prompt user for first start time
        Label(self.root, text = "Start Time - 24hr clock (HHMM) : ").grid(row = (i+1), column = 4)
        #HOUR
        startHourvcmd = (self.root.register(self.validateStartHour), '%P')
        startHourinval = (self.root.register(self.invalidStartHour), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = startHourvcmd, invalidcommand = startHourinval))
        dataArray[index+3].grid(row = (i+1), column = 5)
        #MINUTE
        startMinvcmd = (self.root.register(self.validateStartMin), '%P')
        startMininval = (self.root.register(self.invalidStartMin), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = startMinvcmd, invalidcommand = startMininval))
        dataArray[index+4].grid(row = (i+1), column = 6)

 
        # Prompt user for first End Time
        Label(self.root, text = "End Time : ").grid(row = (i+2), column = 4)
        #HOUR
        endHourvcmd = (self.root.register(self.validateEndHour), '%P')
        endHourinval = (self.root.register(self.invalidEndHour), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = endHourvcmd, invalidcommand = endHourinval))
        dataArray[index+5].grid(row = (i+2), column = 5)
        #MIN
        endMinvcmd = (self.root.register(self.validateEndMin), '%P')
        endMininval = (self.root.register(self.invalidEndMin), '%P')
        dataArray.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = endMinvcmd, invalidcommand = endMininval))
        dataArray[index+6].grid(row = (i+2), column = 6)
        
        Label(self.root, text = 'Total Time : ').grid( row = (i+3), column = 4)


        # Prompt user for Sample Rate
        Label(self.root, text = "Sample Rate 44, 48, 96 (kHz) : ").grid(row = (i+1), column = 7)
        samplevcmd = (self.root.register(self.validateSample), '%P')
        sampleinval = (self.root.register(self.invalidSample), '%P')
        dataArray.append(Entry(self.root, width = 10, validate = 'focusout', validatecommand = samplevcmd, invalidcommand = sampleinval))
        dataArray[7].grid(row = (i+1), column = 8)

 
        # Save Parameter button

        saveParam = Button(self.root, text = 'Save Parameters', command = saveParameters)
        saveParam.grid(row = (i+3), column = 7)

        # Enter new line of paramters
 
        newLine = Button(self.root, text = 'Enter Data', command = newLineEnter)
        newLine.grid(row = (i+3), column = 8)


        Label(self.root, text = "Enter Current Date and Time (YYMMDD) : ").grid(row = (i-1), column = 0)
         
        curYearvcmd = (self.root.register(self.validateCurYear), '%P')
        curYearinval = (self.root.register(self.invalidCurYear), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curYearvcmd, invalidcommand = curYearinval))
        currentInfo[0].grid(row = (i-1), column = 1)
        
        curMonthvcmd = (self.root.register(self.validateCurMonth), '%P')
        curMonthinval = (self.root.register(self.invalidCurMonth), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curMonthvcmd, invalidcommand = curMonthinval))
        currentInfo[1].grid(row = (i-1), column = 2)
        
        curDayvcmd = (self.root.register(self.validateCurDay), '%P')
        curDayinval = (self.root.register(self.invalidCurDay), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curDayvcmd, invalidcommand = curDayinval))
        currentInfo[2].grid(row = (i-1), column = 3)
        
        Label(self.root, text = "Weekday (Sunday (00) - Saturday (06)) (HHMM) : ").grid(row = i, column = 0)
        curWeekdayvcmd = (self.root.register(self.validateCurWeekday), '%P')
        curWeekdayinval = (self.root.register(self.invalidCurWeekday), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curWeekdayvcmd, invalidcommand = curWeekdayinval))
        currentInfo[3].grid(row = (i), column = 1)
        
        curHourvcmd = (self.root.register(self.validateCurHour), '%P')
        curHourinval = (self.root.register(self.invalidCurHour), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curHourvcmd, invalidcommand = curHourinval))
        currentInfo[4].grid(row = (i), column = 2)
        
        curMinvcmd = (self.root.register(self.validateCurMin), '%P')
        curMininval = (self.root.register(self.invalidCurMin), '%P')
        currentInfo.append(Entry(self.root, width = 5, validate = 'focusout', validatecommand = curMinvcmd, invalidcommand = curMininval))
        currentInfo[5].grid(row = (i), column = 3)




# VALIDATION FUNCTIONS FOR ENTRIES
    def validateYear(self,P):
        # Invalid year if over 2 numbers long and not a digit
        dataArray[index].config(fg = 'black')
        return (len(P) == 2 and P.isdigit())

    def invalidYear(self, P):
        # Create Error message for invalid year
        dataArray[index].delete(0,END)
        dataArray[index].config(fg = 'red')
        dataArray[index].insert(0,'invalid')
        
    def validateMonth(self, P):
        # Invalid month is not number between 1-12 and entry not 2 number long
        dataArray[index+1].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=1 and int(P)<=12)
    
    def invalidMonth(self, P):
        # Create error message for invlid month
        dataArray[index+1].delete(0,END)
        dataArray[index+1].config(fg = 'red')
        dataArray[index+1].insert(0,'invalid')

    def validateDay(self, P):
        # Invalid day is not number 1-31, or 2 numbers long
        dataArray[index+2].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=1 and int(P)<=31)

    def invalidDay(self, P):
        # create error message for invalid day
        dataArray[index+2].delete(0,END)
        dataArray[index+2].config(fg = 'red')
        dataArray[index+2].insert(0,'invalid')

    def validateStartHour(self, P):
        # Invalid start hour is not number 0-23 or 2 numbers long
        dataArray[index+3].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=23)

    def invalidStartHour(self, P):
        # create error message for invalid start hour
        dataArray[index+3].delete(0,END)
        dataArray[index+3].config(fg = 'red')
        dataArray[index+3].insert(0,'invalid')

    def validateStartMin(self, P):
        # Invalid start min is not number 0-59 or 2 numbers long
        dataArray[index+4].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=59)

    def invalidStartMin(self, P):
        # create error message for invalid start min
        dataArray[index+4].delete(0,END)
        dataArray[index+4].config(fg = 'red')
        dataArray[index+4].insert(0,'invalid')

    def validateEndHour(self, P):
        # Invalid end hour is not number 0-23 or 2 numbers long
        dataArray[index+5].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=23 and int(P)>= int(dataArray[index+3].get()))

    def invalidEndHour(self, P):
        # create error message for invalid end hour
        dataArray[index+5].delete(0,END)
        dataArray[index+5].config(fg = 'red')
        dataArray[index+5].insert(0,'invalid')

    def validateEndMin(self, P):
        # Invalid end hour is not number 0-59 or 2 numbers long
        dataArray[index+6].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=59)

    def invalidEndMin(self, P):
        # create error message for invalid end min
        dataArray[index+6].delete(0,END)
        dataArray[index+6].config(fg = 'red')
        dataArray[index+6].insert(0,'invalid')

    def validateSample(self, P):
        # Invalid sample is not numbers 44, 48, 96 and 2 numbers long
        dataArray[index+7].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and (int(P)== 44 or int(P)==48 or int(P)==96))

    def invalidSample(self, P):
        # create error message for invalid end min
        dataArray[index+7].delete(0,END)
        dataArray[index+7].config(fg = 'red')
        dataArray[index+7].insert(0,'invalid')


#VALIDATE CURRENT DATE AND TIME
    def validateCurYear(self,P):
        # Invalid year if over 2 numbers long and not a digit
        currentInfo[0].config(fg = 'black')
        return (len(P) == 2 and P.isdigit())

    def invalidCurYear(self, P):
        # Create Error message for invalid year
        currentInfo[0].delete(0,END)
        currentInfo[0].config(fg = 'red')
        currentInfo[0].insert(0,'invalid')
        
    def validateCurMonth(self, P):
        # Invalid month is not number between 1-12 and entry not 2 number long
        currentInfo[1].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=1 and int(P)<=12)
    
    def invalidCurMonth(self, P):
        # Create error message for invlid month
        currentInfo[1].delete(0,END)
        currentInfo[1].config(fg = 'red')
        currentInfo[1].insert(0,'invalid')

    def validateCurDay(self, P):
        # Invalid day is not number 1-31, or 2 numbers long
        currentInfo[2].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=1 and int(P)<=31)

    def invalidCurDay(self, P):
        # create error message for invalid day
        currentInfo[2].delete(0,END)
        currentInfo[2].config(fg = 'red')
        currentInfo[2].insert(0,'invalid')

    def validateCurWeekday(self, P):
        # Invalid weekday is not number 00-06 or 2 numbers long
        currentInfo[3].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=6)

    def invalidCurWeekday(self, P):
        # create error message for invalid start hour
        currentInfo[3].delete(0,END)
        currentInfo[3].config(fg = 'red')
        currentInfo[3].insert(0,'invalid')

    def validateCurHour(self, P):
        # Invalid hour is not 2 digits or 0-23
        currentInfo[4].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=23)

    def invalidCurHour(self, P):
        # create error message for invalid start min
        currentInfo[4].delete(0,END)
        currentInfo[4].config(fg = 'red')
        currentInfo[4].insert(0,'invalid')

    def validateCurMin(self, P):
        # Invalid start min is not number 0-59 or 2 numbers long
        currentInfo[5].config(fg = 'black')
        return (len(P)==2 and P.isdigit() and int(P)>=0 and int(P)<=59)

    def invalidCurMin(self, P):
        # create error message for invalid start min
        currentInfo[5].delete(0,END)
        currentInfo[5].config(fg = 'red')
        currentInfo[5].insert(0,'invalid')




app = scheduleApp()




