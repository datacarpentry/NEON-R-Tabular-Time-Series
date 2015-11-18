## ----load-libraries------------------------------------------------------

# Load packages required for entire script
library(lubridate)  #work with dates

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#Load csv file of 15 min meterological data from Harvard Forest
#Factors=FALSE so strings, series of letters/ words/ numerals, remain characters
harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                     stringsAsFactors = FALSE)

#what type of R object is our imported data?
class(harMet_15Min)

#what data classes are within our R object? 
#What is our date-time field called?
str(harMet_15Min)


## ----view-date-structure-------------------------------------------------
#view field data class
class(harMet_15Min$datetime)

#view sample data
head(harMet_15Min$datetime)


## ----as-date-only, results="hide"----------------------------------------

#convert field to date format
har_dateOnly <- as.Date(harMet_15Min$datetime)

#view data
head(har_dateOnly)


## ----explore-as_date-----------------------------------------------------
#Convert character data to date (no time) 
myDate <- as.Date("2015-10-19 10:15")   
str(myDate)
head(myDate)

#whhat happens if the date has text at the end?
myDate2 <- as.Date("2015-10-19Hello")   
str(myDate2)
head(myDate2)


## ----explore-POSIXct-----------------------------------------------------
#Convert character data to date and time.
timeDate <- as.POSIXct("2015-10-19 10:15")   
str(timeDate)
head(timeDate)


## ----time-zone-----------------------------------------------------------
#view date - notice the time zone - MDT (mountain daylight time)
timeDate


## ----explore-POSIXct2----------------------------------------------------
unclass(timeDate)

## ----explore-POSIXlt-----------------------------------------------------
#Convert character data to POSIXlt date and time
timeDatelt<- as.POSIXlt("2015-10-1910:15")  
str(timeDatelt)
head(timeDatelt)

unclass(timeDatelt)

## ----view-date-----------------------------------------------------------

#view one date time entry
harMet_15Min$datetime[1]


## ----format-date---------------------------------------------------------
#convert single instance of date/time in format year-month-day hour:min:sec
as.POSIXct(harMet_15Min$datetime[1],format="%Y-%m-%dT%H:%M")

##The format of date-time MUST match the specified format or the field will not
# convert
as.POSIXct(harMet_15Min$datetime[1],format="%m-%d-%YT%H:%M")


## ----time-zone-HarMet----------------------------------------------------
#checking time zone of data
tz(harMet_15Min)

## ----assign-time-zone----------------------------------------------------

#assign time zone to just the first entry
as.POSIXct(harMet_15Min$datetime[1],
            format = "%Y-%m-%dT%H:%M",
            tz = "America/New_York")


## ----POSIX-convert-best-practice-code------------------------------------
#convert to date-time class
harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                format = "%Y-%m-%dT%H:%M",
                                tz = "America/New_York")

#view format of the newly defined datetime data.frame column 
str(harMet_15Min$datetime)


