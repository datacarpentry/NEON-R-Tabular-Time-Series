## ----load-data-----------------------------------------------------------
#Remember it is good coding technique to add additional libraries to the top of
  #your script 
library(lubridate) #for working with dates
library(ggplot2)  #for creating graphs
library(scales)   #to access breaks/formatting functions
library(gridExtra) #for arranging plots
library(dplyr)  #for subsetting by season

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#daily HARV met data, 2009-2011
harMetDaily.09.11 <- read.csv(file="AtmosData/HARV/Met_HARV_Daily_2009_2011.csv",
                     stringsAsFactors = FALSE)

#covert date to POSIXct date-time class
harMetDaily.09.11$date <- as.POSIXct(harMetDaily.09.11$date)

#monthly HARV temperature data, 2009-2011
harTemp.monthly.09.11<-read.csv(file="AtmosData/HARV/Temp_HARV_Monthly_09_11.csv",
                                stringsAsFactors=FALSE)

#convert datetime from chr to datetime class & rename date for clarification
harTemp.monthly.09.11$date <- as.POSIXct(harTemp.monthly.09.11$datetime)

## ----PAR-v-precip--------------------------------------------------------
#PAR v precip 
par.precip <- ggplot(harMetDaily.09.11,aes(prec, part)) +
           geom_point(na.rm=TRUE) +    #removing the NA values
           ggtitle("Daily Precipitation and PAR at Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Total Precipitation (mm)") + ylab("Mean Total PAR")
par.precip

## ----subsetting-by-season-1----------------------------------------------
#create a column of only the month
harMetDaily.09.11 <- harMetDaily.09.11  %>% 
  mutate(month=format(date,"%m"))

#check structure of this variable
str(harMetDaily.09.11$month)

## ----subsetting-by-season-2----------------------------------------------
harMetDaily.09.11 <- harMetDaily.09.11 %>% 
  mutate(season = 
           ifelse(month %in% c("12", "01", "02"), "winter",
           ifelse(month %in% c("03", "04", "05"), "spring",
           ifelse(month %in% c("06", "07", "08"), "summer",
           ifelse(month %in% c("09", "10", "11"), "fall", "Error")))))

#check to see if this worked
head(harMetDaily.09.11$month)
head(harMetDaily.09.11$season)
tail(harMetDaily.09.11$month)
tail(harMetDaily.09.11$season)

## ----plot-by-season------------------------------------------------------

#run this code to plot the same plot as before but with one plot per season
par.precip + facet_grid(. ~ season)

## ----par.precip-rerun, echo=FALSE----------------------------------------
par.precip <- ggplot(harMetDaily.09.11,aes(prec, part)) +
           geom_point(na.rm=TRUE) +    #removing the NA values
           ggtitle("Daily Precipitation and PAR at Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Total Precipitation (mm)") + ylab("Mean Total PAR")

## ----plot-by-season2-----------------------------------------------------
par.precip + facet_grid(. ~ season)

# for a landscape orientation of the plots we change the order of arguments in facet_grid():
par.precip + facet_grid(season ~ .)


#and another arrangement of plots:
par.precip + facet_wrap(~season, ncol = 2)


## ----assigning-level-to-season-------------------------------------------
harMetDaily.09.11$season<- factor(harMetDaily.09.11$season, level=c("spring",
                                                    "summer","fall","winter")) 

#check to make sure it worked
str(harMetDaily.09.11$season)

#rerun original par.precip code to incorporate the levels. 
par.precip <- ggplot(harMetDaily.09.11,aes(prec, part)) +
         geom_point(na.rm=TRUE) +    #removing the NA values
        ggtitle("Daily Precipitation and PAR at Harvard Forest") +
         theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
         theme(text = element_text(size=20)) +
         xlab("Total Precipitation (mm)") + ylab("Mean Total PAR")
           
#new facetted plots
par.precip + facet_grid(. ~ season)


## ----challenge-code-prec.airtemp, echo=FALSE-----------------------------
harMetDaily.09.11$season<- factor(harMetDaily.09.11$season, level=c("winter",
                                                  "spring", "summer", "fall"))
prec.airtemp <- ggplot(harMetDaily.09.11,aes(airt, prec)) +
           geom_point(na.rm=TRUE) +    #removing the NA values
           ggtitle("Harvard Forest\n 2009-2011") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Air Temperature (Celcius)") + ylab("Precipitation (daily mm)")

prec.airtemp + facet_grid(.~season)
prec.airtemp + facet_grid(season~.)


## ----plot-bar-and-line---------------------------------------------------

plot1<- ggplot(harMetDaily.09.11) +
           geom_bar(aes(x=time, y=prec), stat="identity", na.rm=TRUE) +
           ggtitle("Harvard Forest\n 2009-2011") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Precipitation (daily mm)") 

plot2<-ggplot(harMetDaily.09.11) +
           geom_line(aes(x=time, y=airt), stat="identity", na.rm=TRUE) +
           ggtitle("Harvard Forest\n 2009-2011") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Air Temp (C)") 

grid.arrange(plot1, plot2, cols=2)

## ----read-NDVI-----------------------------------------------------------
#first read in the NDVI CSV data
NDVI.2009 <- read.csv(file="Landsat_NDVI/Harv2009NDVI.csv", stringsAsFactors = FALSE)
#check out the data
str(NDVI.2009)
View(NDVI.2009)

## ----dplyr-to-subset-----------------------------------------------------
harMet.daily2009 <- harMet.daily %>% 
  mutate(year = year(date)) %>%   #need to create a year only column first
  filter(year == "2009")


## ----plot-PAR-NDVI-------------------------------------------------------
#create plot of julian day vs. PAR
par.2009 <- ggplot(harMet.daily2009, aes(jd,part))+
  geom_point(na.rm=TRUE)+
  ggtitle("Daily PAR at Harvard Forest, 2009")+
  theme(legend.position = "none", plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) 

#create plot of julian day vs. NDVI
NDVI.2009 <- ggplot(NDVI.2009,aes(julianDays, meanNDVI))+
  geom_point(aes(color = "green", size = 4)) +
  ggtitle("Daily NDVI at Harvard Forest, 2009")+
  theme(legend.position = "none", plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) 

#display the plots together
grid.arrange(par.2009, NDVI.2009) 

## ----plot-airt-NDVI------------------------------------------------------
#Let's take a look at air temperature too
airt.2009 <- ggplot(harMet.daily2009, aes(jd,airt))+
  geom_point(na.rm=TRUE)+
  ggtitle("Daily Air Temperature at Harvard Forest, 2009")+
  theme(legend.position = "none", plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) 

grid.arrange(airt.2009, NDVI.2009)

## ----plot-PAR-air-NDVI---------------------------------------------------
#all 3 together
grid.arrange(par.2009, airt.2009, NDVI.2009)

