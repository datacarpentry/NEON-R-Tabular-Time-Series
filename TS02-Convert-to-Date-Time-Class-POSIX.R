## ----load-libraries------------------------------------------------------

# Load packages required for entire script
library(lubridate)  #work with dates
library(ggplot2)  #efficient plotting


## ----import-csv----------------------------------------------------------

#Load csv file of 15 min meterological data from Harvard Forest
#don't load strings (a series of letters or numerals) as factors so they remain characters
harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                     stringsAsFactors = FALSE)

#what type of R object is our imported data?
class(harMet_15Min)

#what type of R object is our imported data?
str(harMet_15Min)


## ----view-date-structure-------------------------------------------------
#view field format
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
#view date - notice the time zone - MDT (mountain daily time)
timeDate


## ----explore-POSIXct2----------------------------------------------------
unclass(timeDate)

## ----explore-POSIXlt-----------------------------------------------------

#Convert character data to POSIXlt date and time
timeDatelt<- as.POSIXlt("2015-10-1910:15")  
str(timeDatelt)
head(timeDatelt)

unclass(timeDatelt)

## ----POSIX-lookup--------------------------------------------------------
#help for POSIXlt
?POSIXlt

## ----convert-data--------------------------------------------------------

#view one date time entry
harMet_15Min$datetime[1]

#convert single instance to a date/time
as.POSIXct(harMet_15Min$datetime[1],format="%Y-%m-%dT%H:%M")



## ----assign-time-zone----------------------------------------------------

#assign time zone to the field
as.POSIXct(harMet_15Min$datetime[1],
            format = "%Y-%m-%d %H:%M",
            tz = "America/New_York")


## ----POSIX-convert-------------------------------------------------------
#convert to date-time class
harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                format = "%Y-%m-%dT%H:%M",
                                tz = "America/New_York")

#view format of the newly defined datetime data.frame column 
str(harMet_15Min$datetime)


## ----julian-day-convert--------------------------------------------------
# convert to julian days
# to learn more about it type
?yday

harMet_15Min$julian <- yday(harMet_15Min$datetime)  
#make sure it worked all the way through.  Dataframe was 30 variables so julian should be 31st.
head(harMet_15Min$julian) 
tail(harMet_15Min$julian)


