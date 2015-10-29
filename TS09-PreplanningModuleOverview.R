## ----project-organization------------------------------------------------


## ----load-libraries-date-function----------------------------------------
# Load packages
#load ggplot for plotting 
library(ggplot2)
#the scales library supports breaks and formatting in ggplot
library(scales)

# Load file and make it work
#don't load strings as factors
#read in 15 min average data 
harMet <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv", stringsAsFactors = FALSE)


## ----Data-Structure------------------------------------------------------
#Check the variable types. Are they the type you think they should be. Int, num,  (EXPAND IF NOT PREVIOUSLY DISCUSSED BY RASTER GROUP)

#



## ----gaps----------------------------------------------------------------


## ----import-harvard-met-data-15min---------------------------------------
#From Character to Time 

#In structure data is NA;  but it isn't.  Fix. 
#clean up dates
#remove the "T"
harMet$datetime <- fixDate(harMet$datetime,"America/New_York")

# Replace T and Z with a space
harMet$datetime <- gsub("T|Z", " ", harMet$datetime)
  
#set the field to be a date field
harMet$datetime <- as.POSIXct(harMet$datetime,format = "%Y-%m-%d %H:%M", 
                          tz = "GMT")

#list of time zones
#https://en.wikipedia.org/wiki/List_of_tz_database_time_zones
#convert to local time for pretty plotting
attributes(harMet$datetime)$tzone <- "America/New_York"



#as.Date("2006-02-01 00:00:00")

## ----plot-daylength------------------------------------------------------

#convert to julian days

#stack the data frame
dayLengthHar2011.st <- stack(dayLengthHar2011[2:13])
#remove NA values
dayLengthHar2011.st <- dayLengthHar2011.st[complete.cases(dayLengthHar2011.st),]
#add julian days (count)
dayLengthHar2011.st$JulianDay<-seq.int(nrow(dayLengthHar2011.st))
#fix names
names(dayLengthHar2011.st) <- c("Hours","Month","JulianDay")

#plot Years Worth of  data
ggplot(dayLengthHar2011.st, aes(JulianDay,Hours)) +
  geom_point()+
  ggtitle("Day Length\nJan 2011") +
  xlab("Julian Days") + ylab("Day Length (Hours)") +
  theme(text = element_text(size=20))


## ----dply-subsetting-----------------------------------------------------
#subset out some of the data - 2010-2013 
yr.09.11 <- subset(harMet, datetime >= as.POSIXct('2009-01-01 00:00') & datetime <=
as.POSIXct('2011-01-01 00:00'))


## ----descriptive-stats---------------------------------------------------
#basic descriptive stats


#aggregating


## ----basic-plotting------------------------------------------------------
#plot Some Air Temperature Data
myPlot <- ggplot(yr.09.11,aes(datetime, airt)) +
           geom_point() +
           ggtitle("15 min Avg Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_datetime(labels = date_format("%m/%d/%y"))




## ----convert-daily-------------------------------------------------------
#convert to daily  julian days
temp.daily <- aggregate(yr.09.11["airt"], format(yr.09.11["datetime"],"%Y-%j"),
                 mean, na.rm = TRUE) 


#not working yet - weird!
#qplot(temp.daily$datetime,temp.daily$airt)
#ggplot(temp.daily,aes(datetime, airt)) +
#           geom_point() +
#           ggtitle("Daily Avg Air Temperature\nHarvard Forest") +
#           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
#          theme(text = element_text(size=20)) +
#           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
#myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


## ----Challenge-answers---------------------------------------------------
#1. Import daily .csv
#2. Check out the data structure
#3. Convert time 
#4. Make pretty plot
#read in daily data  ->CHANGE TO USING THE AGGREGATE DATA JUST CREATED
harMetDaily <- read.csv(file="AtmosData/HARV/hf001-06-daily-m.csv")

#set the field to be a date field
harMetDaily$date <- as.Date(harMetDaily$date, format = "%Y-%m-%d")

#subset out some of the data - 2010-2013 
yr.09.11_monAvg <- subset(harMetDaily, date >= as.Date('2009-01-01') & date <=
as.Date('2011-01-01'))

#as.Date("2006-02-01 00:00:00")
#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, airt)) +
           geom_point() +
           ggtitle("Daily Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


#plot Some Precip Data (Challenge?)
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, prec)) +
           geom_point() +
           ggtitle("Daily Precipitation\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))

#plot Some Air Temperature Data
  
myPlot <- ggplot(yr.09.11_monAvg,aes(date, part)) +
           geom_point() +
           ggtitle("Daily Avg Total PAR\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Total PAR")

#format x axis with dates
myPlot + scale_x_date(labels = date_format("%m/%d/%y"))


