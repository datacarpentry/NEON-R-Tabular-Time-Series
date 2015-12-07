## ----load-libraries------------------------------------------------------
# Load packages required for entire script
library(lubridate)  #work with dates
library(ggplot2)  # plotting

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#Load csv file of 15 min meteorological data from Harvard Forest
#Factors=FALSE so strings, series of letters/ words/ numerals, remain characters
harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                     stringsAsFactors = FALSE)
#convert date time
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


## ----write-csv-----------------------------------------------------------
#writing the subset of harMet15 data to .csv
write.csv(harMet15.09.11, file="Met_HARV_15min_2009_2011.csv")


## ----challenge-code-subsetting, include=TRUE, results="hide", echo=FALSE----
harMet15_July2010 <- subset(harMet15.09.11, datetime >= as.POSIXct('2010-07-01 00:00',
        tz = "America/New_York") & datetime <=
        as.POSIXct('2010-07-31 23:59', tz = "America/New_York"))

#did it work?
head(harMet15_July2010$datetime)
tail(harMet15_July2010$datetime)

#ploting precip in July
qplot (datetime, prec,
       data= harMet15_July2010,
       main= "Precipitation in July 2010\nHarvard Forest",
       xlab= "Date", ylab= "Precipitation (mm)")

## ----missing values------------------------------------------------------

#Check for NA values
sum(is.na(harMet15.09.11$datetime))
sum(is.na(harMet15.09.11$airt))
sum(is.na(harMet15.09.11$prec))
sum(is.na(harMet15.09.11$parr))


## ----na-in-calculations--------------------------------------------------
#calculate mean of air temperature
mean(harMet15.09.11$airt)


## ----na-rm---------------------------------------------------------------
#calculate mean of air temperature, ignore NA values
mean(harMet15.09.11$airt, na.rm=TRUE)


## ----Challenge-code-harMet.daily, include=TRUE, results="hide", echo=FALSE----

#1. import daily file
harMet.daily <- read.csv("AtmosData/HARV/hf001-06-daily-m.csv", 
      stringsAsFactors = FALSE)
#check it out
str(harMet.daily)

#2. Metadata
#Differences in 2 variable names PAR=part, DateTime=date

#3. convert date 
harMet.daily$date <- as.Date(harMet.daily$date,format = "%Y-%m-%d")
#check it out
str(harMet.daily [1])


#4. Check for NA values
sum(is.na(harMet.daily$date))
sum(is.na(harMet.daily$airt))
sum(is.na(harMet.daily$prec))
sum(is.na(harMet.daily$part))
#OuputNote: PART is missing 1032 values

#5. subset out some of the data - 2009-2011
harMetDaily.09.11 <- subset(harMet.daily, date >= as.Date('2009-01-01')
                                        & date <= as.Date('2011-12-31'))

#check it
head(harMetDaily.09.11$date)
tail(harMetDaily.09.11$date)

#do we still have the NA in part?
sum(is.na(harMetDaily.09.11$part))
#Output note: now only 1 NA!

#6. Write .csv
write.csv(harMetDaily.09.11, file="Met_HARV_Daily_2009_2011.csv")


#7.  Plotting air temp 2009-2011
qplot (x=date, y=airt,
       data=harMetDaily.09.11,
       main= "Average Air Temperature \n Harvard Forest",
       xlab="Date", ylab="Temperature (°C)")

