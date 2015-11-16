## ----load-libraries------------------------------------------------------

# Load packages required for entire script
library(lubridate)  #work with dates
library(ggplot2)  #efficient plotting


#load data
harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                     stringsAsFactors = FALSE)

#still getting NA values when i do this conversion
sum(is.na(harMet_15Min$datetime))

#convert to date-time class
harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                format = "%Y-%m-%dT%H:%M",
                                tz = "America/New_York")

## ----subset-by-time------------------------------------------------------

#subset out some of the data - 2009-2011
harMet15.09.11 <- subset(harMet_15Min, datetime >= as.POSIXct('2009-01-01 00:00',
        tz = "America/New_York") & datetime <=
        as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))

#check to make sure it worked.
head(harMet15.09.11[1])
tail(harMet15.09.11[1])


## ----missing values------------------------------------------------------

#Check for NA values
sum(is.na(harMet_15Min$datetime))
sum(is.na(harMet15$airt))
sum(is.na(harMet15$prec))
sum(is.na(harMet15$parr))


## ----Challenge1-code-----------------------------------------------------

#import daily file
harMet.daily <- read.csv("AtmosData/HARV/hf001-06-daily-m.csv", 
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
harMetDaily.09.11 <- subset(harMet.daily, date >= as.POSIXct('2009-01-01',
        tz = "America/New_York") & date <=
        as.POSIXct('2011-12-31', tz = "America/New_York"))

#check it
head(harMetDaily.09.11$date)
tail(harMetDaily.09.11$date)

#do we still have the NA in part?
sum(is.na(harMetDaily.09.11$part))
#Output note: now only 1 NA!

