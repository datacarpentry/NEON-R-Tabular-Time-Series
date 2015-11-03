## ----load-libraries------------------------------------------------------
# Load packages required for entire script
library(lubridate)  #working with dates


## ----missing values------------------------------------------------------
#Check for NA values
sum(is.na(harMet15$datetime))
sum(is.na(harMet15$airt))
sum(is.na(harMet15$prec))
sum(is.na(harMet15$parr))
    


## ----date-time-----------------------------------------------------------
#convert from character to time type
#datetime input looks like this: 2005-01-01T00:15

#remove the "T" and replace it with a space
#gsub() replaces all occurances; sub() just replaces first occurance in the set
harMet15$datetime <- gsub("T", " ", harMet15$datetime)
#make sure it worked
head(harMet15)

## ----explore-as_date-----------------------------------------------------
#Convert char data to date (no time) 
date <- as.Date("2015-10-19 10:15")   
str(date)
head(date)

## ----explore-POSIXct-----------------------------------------------------
#Convert char data to date and time.
TimeDate <- as.POSIXct("2015-10-19 10:15")   
str(TimeDate)
head(TimeDate)


## ----explore-POSIXct2----------------------------------------------------
unclass(TimeDate)

## ----explore-POSIXlt-----------------------------------------------------
#Convert char data to POSIXlt date and time
TimeDatelt<- as.POSIXlt("2015-10-19 10:15")  
str(TimeDatelt)
head(TimeDatelt)

unclass(TimeDatelt)

## ----POSIX-lookup--------------------------------------------------------
#help for POSIXlt
?POSIXlt

## ----POSIX-convert-------------------------------------------------------
#convert to date-time class
harMet15$datetime <- as.POSIXct(harMet15$datetime,format = "%Y-%m-%d %H:%M",
    tz = "America/New_York")

#make sure it worked.  Adding [1] allows us to just look at structure for first
#variable in dataframe instead of all of them, giving a cleaner output.  If we #wanted the 4th column/variable we would type [4].
str(harMet15[1])

## ----julian-day-convert--------------------------------------------------
# convert to julian days
# here we will use yday, which is a function from the lubridate package;
# to learn more about it type
?yday

harMet15$julian <- yday(harMet15$datetime)  
#make sure it worked all the way through.  Dataframe was 30 variables so julian should be 31st.
head(harMet15[31]) 
tail(harMet15[31])


## ----subsetting----------------------------------------------------------

#subset out some of the data - 2009-2011
harMet15.09.11 <- subset(harMet15, datetime >= as.POSIXct('2009-01-01 00:00',
        tz = "America/New_York") & datetime <=
        as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))

#check to make sure it worked.
summary(harMet15.09.11[1])

## ----Challenge1-code-----------------------------------------------------

#import daily file
harMet.daily <- read.csv("data/AtmosData/HARV/hf001-06-daily-m.csv", 
      stringsAsFactors = FALSE)
#check it out
str(harMet.daily)

#Metadata
#Differences in 2 variable names PAR=part, DateTime=date
#Has Julian days already calculated name =jd

#Check for NA values
sum(is.na(harMet.daily$date))
sum(is.na(harMet.daily$airt))
sum(is.na(harMet.daily$prec))
sum(is.na(harMet.daily$part))
#OuputNote: PART is missing 1032 values

#convert date 
harMet.daily$date <- as.POSIXct(harMet.daily$date,format = "%Y-%m-%d",
      tz = "America/New_York")
#check it out
str(harMet.daily [1])

#julian data - already in file. Field jd

#subset out some of the data - 2009-2011
harMetDaily.09.11 <- subset(harMet.daily, date >= as.POSIXct('2009-01-01 00:00',
        tz = "America/New_York") & date <=
        as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))

#check it
summary(harMetDaily.09.11$date)

#do we still have the NA in part?
sum(is.na(harMetDaily.09.11$part))
#Output note: now only 1 NA!

