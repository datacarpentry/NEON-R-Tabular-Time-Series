## ----load-data-----------------------------------------------------------
#Remember it is good coding technique to add additional libraries to the top of
  #your script 
library(lubridate) #for working with dates
library(ggplot2)  #for creating graphs
library(scales)   #to access breaks/formatting functions
library(gridExtra) #for arranging plots

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#daily HARV met data, 2009-2011
harMetDaily.09.11 <- read.csv(file="AtmosData/HARV/Met_HARV_Daily_2009_2011.csv",
                     stringsAsFactors = FALSE)

#covert date to POSIXct date-time class
harMetDaily.09.11$date <- as.POSIXct(harMetDaily.09.11$date)

#monthly HARV temperature data, 2009-2011
harTemp.monthly.09.11<-read.csv(file=
                        "AtmosData/HARV/Temp_HARV_Monthly_09_11.csv",
                        stringsAsFactors=FALSE)
#convert datetime from chr to datetime class & rename date for clarification
harTemp.monthly.09.11$date <- as.POSIXct(harTemp.monthly.09.11$datetime)

## ----qplot---------------------------------------------------------------
qplot (x=date, y=airt,
      data= harMetDaily.09.11,
      main= "Air temperature Harvard Forest\n 2009-2011",
      xlab= "Date", ylab= "Temperature (°C)")

## ----basic-ggplot2-------------------------------------------------------
#plot Air Temperature Data across 2009-2011 using 15-minute data
AirTempDailya <- ggplot(harMetDaily.09.11, aes(date, airt)) +
           geom_point(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                      # that 2 NA values were removed.
           ggtitle("Air Temperature Harvard Forest\n 2009-2011") +
           xlab("Date") + ylab("Air Temperature (C)")
AirTempDailya

## ----nice-x-axis---------------------------------------------------------
#format x-axis: dates
AirTempDailyb <- AirTempDailya + (scale_x_datetime(labels=date_format("%b %y")))
AirTempDailyb

## ----nice-font-----------------------------------------------------------
#format x axis with dates
AirTempDaily<-AirTempDailyb +
  #theme(plot.title) allows to format the Title seperately from other text
  theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
  #theme(text) will format all text that isn't specifically formatted elsewhere
  theme(text = element_text(size=18)) 
AirTempDaily

## ----challenge-code-ggplot-precip, echo=FALSE----------------------------
PrecipDaily <- ggplot(harMetDaily.09.11, aes(date, prec)) +
           geom_point() +
           ggtitle("Daily Precipitation Harvard Forest\n 2009-2011") +
            xlab("Date") + ylab("Precipitation (mm)") +
            scale_x_datetime(labels=date_format ("%m-%y"))+
           theme(plot.title = element_text(lineheight=.8, face="bold",
                 size = 20)) +
           theme(text = element_text(size=18))

PrecipDaily

## ----ggplot-geom_bar-----------------------------------------------------
PrecipDailyBarA <- ggplot(harMetDaily.09.11, aes(date, prec)) +
           geom_bar(stat="identity") +
           ggtitle("Daily Precipitation\n Harvard Forest") +
            xlab("Date") + ylab("Precipitation (mm)") +
            scale_x_datetime(labels=date_format ("%b-%y")) +
            theme(plot.title = element_text(lineheight=.8, face="bold",
                 size = 20)) +
           theme(text = element_text(size=18))
PrecipDailyBarA

## ----ggplot-color--------------------------------------------------------
#specifying color by name
PrecipDailyBarB <- PrecipDailyBarA+
  geom_bar(stat="identity", colour="darkblue")

PrecipDailyBarB

#specifying color by hexidecimal code
AirTempDaily+geom_point(colour="#66ffb3", na.rm=TRUE)


## ----ggplot-geom_lines---------------------------------------------------
AirTempDailyline <- ggplot(harMetDaily.09.11, aes(date, airt)) +
           geom_line(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                      # that 2 NA values were removed.
           ggtitle("Air Temperature Harvard Forest\n 2009-2011") +
           xlab("Date") + ylab("Air Temperature (C)") +
          theme(plot.title = element_text(lineheight=.8, face="bold", 
                                          size = 20)) +
           theme(text = element_text(size=18))
AirTempDailyline

## ----challenge-code-geom_lines&points, echo=FALSE------------------------
AirTempDaily + geom_line(na.rm=TRUE) 

## ----ggplot-trend-line---------------------------------------------------
#adding on a trend lin using loess
AirTempDailyTrend <- AirTempDaily + stat_smooth(colour="green")
AirTempDailyTrend

## ----challenge-code-linear-trend, echo=FALSE-----------------------------
ggplot(harMetDaily.09.11, aes(date, prec)) +
      geom_bar(stat="identity", colour="darkorchid4") + #dark orchid 4 = #68228B
      ggtitle("Daily Precipitation with Linear Trend\n Harvard Forest") +
      xlab("Date") + ylab("Precipitation (mm)") +
      scale_x_datetime(labels=date_format ("%b %y"))+
      theme(plot.title = element_text(lineheight=.8, face="italic",
                 size = 20)) +
      theme(text = element_text(size=18))+
      stat_smooth(method="lm", colour="grey")

## ----plot-airtemp-Monthly, echo=FALSE------------------------------------
AirTempMonthly <- ggplot(harTemp.monthly.09.11, aes(date, mean_airt)) +
           geom_point() +
           ggtitle("Average Monthly Air Temperature\n Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",
                size = 20)) +
           theme(text = element_text(size=18)) +
           xlab("Date") + ylab("Air Temperature (C)") +
          scale_x_datetime(labels=date_format ("%b%y"))
AirTempMonthly


## ----compare-precip------------------------------------------------------
grid.arrange(AirTempDaily, AirTempMonthly, ncol=1)

## ----challenge-code-grid-arrange, echo=FALSE-----------------------------
grid.arrange(AirTempDaily, AirTempMonthly, ncol=2)

