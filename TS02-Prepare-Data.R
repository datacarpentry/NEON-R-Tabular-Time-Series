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

#1st remove the "T" and replace it with a space
#gsub() replaces all occurances; sub() just replaces first occurance
harMet15$datetime <- gsub("T", " ", harMet15$datetime)
#make sure it worked
head(harMet15)

## ----POSIX---------------------------------------------------------------
#2nd convert to date-time class
harMet15$datetime <- as.POSIXct(harMet15$datetime,format = "%Y-%m-%d %H:%M",
    tz = "America/New_York")
#make sure it worked
str(harMet15)


## ----julian-day-convert--------------------------------------------------

#convert to julian days
#here we will use yday, which is a function from the lubridate package; to learn
# more about it type
?yday
harMet15$julian <- yday(harMet15$datetime)  
#make sure it worked
head(harMet15) 
tail(harMet15)


## ----subsetting----------------------------------------------------------

#subset out some of the data - 2009-2011
yr.09.11 <- subset(harMet15, datetime >= as.POSIXct('2009-01-01 00:00', tz = "America/New_York") & datetime <=
as.POSIXct('2011-12-31 23:45', tz = "America/New_York"))


## ----challenge-code------------------------------------------------------

#import daily file
harMet.daily <- read.csv("data/AtmosData/HARV/hf001-06-daily-m.csv", stringsAsFactors = FALSE)
#check it out
str(harMet.daily)
head(harMet.daily)

#convert date
harMet.daily$date <- as.POSIXct(harMet.daily$date,format = "%Y-%m-%d",tz = "America/New_York")
#check it out
str(harMet.daily)
head(harMet.daily)

#add and calc julian day
harMet.daily$julian <- yday(harMet.daily$date)
#check it
head(harMet.daily)
str(harMet.daily)

