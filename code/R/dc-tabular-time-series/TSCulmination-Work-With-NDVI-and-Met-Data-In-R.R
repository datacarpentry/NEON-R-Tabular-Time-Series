## ----read-NDVI-----------------------------------------------------------
#Remember it is good coding technique to add additional libraries to the top of
  #your script 
library(lubridate) #for working with dates
library(ggplot2)  #for creating graphs
library(scales)   #to access breaks/formatting functions
library(gridExtra) #for arranging plots
library(grid)   #for arrangeing plots
library(dplyr)  #for subsetting by season

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#first read in the NDVI CSV data
NDVI.2011 <- read.csv(
  file="NEON-DS-Met-Time-Series/HARV/NDVI/meanNDVI_HARV_2011.csv", 
  stringsAsFactors = FALSE
  )

#check out the data
str(NDVI.2011)
head(NDVI.2011)

## ----challenge-code-convert-date, include=TRUE, results="hide", echo=FALSE----
#convert chr class Date to date class Date
NDVI.2011$Date<- as.Date(NDVI.2011$Date)
#double check
str(NDVI.2011)

## ----dplyr-to-subset, include=TRUE, results="hide", echo=FALSE-----------
#Use dplyr to subset only 2011 data
harMet.daily2011 <- harMetDaily.09.11 %>% 
  mutate(year = year(date)) %>%   #need to create a year only column first
  filter(year == "2011")

#convert data from POSIX class to Date class; both "date" vars. now Date class
harMet.daily2011$date<-as.Date(harMet.daily2011$date)

## ----plot-PAR-NDVI-------------------------------------------------------
#create plot of julian day vs. PAR
plot.par.2011 <- ggplot(harMet.daily2011, aes(date, part))+
  geom_point(na.rm=TRUE) +
  ggtitle("Daily PAR at Harvard Forest, 2011")+
  theme(legend.position = "none",
        plot.title = element_text(lineheight=.8, face="bold",size = 20),
        text = element_text(size=20))

plot.NDVI.2011 <- ggplot(NDVI.2011, aes(Date, meanNDVI))+
  geom_point(colour = "forestgreen", size = 4) +
  ggtitle("Daily NDVI at Harvard Forest, 2011")+
  theme(legend.position = "none",
        plot.title = element_text(lineheight=.8, face="bold",size = 20),
        text = element_text(size=20))
 
#display the plots together
grid.arrange(plot.par.2011, plot.NDVI.2011) 

## ----plot-same-xaxis-----------------------------------------------------
plot2.par.2011 <- plot.par.2011 +
  scale_x_date(labels = date_format("%b %d"),
               breaks = "3 months", minor_breaks= "1 week",
               limits=c(min=min(NDVI.2011$Date),max=max(NDVI.2011$Date)))+
  ylab("Total PAR") + xlab ("")
 

plot2.NDVI.2011 <- plot.NDVI.2011 +
  scale_x_date(labels = date_format("%b %d"),
               breaks = "3 months", minor_breaks= "1 week",
               limits=c(min=min(NDVI.2011$Date),max=max(NDVI.2011$Date)))+
  ylab("Total NDVI") + xlab ("Date")

grid.arrange(plot2.par.2011, plot2.NDVI.2011) 

## ----challengeplot-same-xaxis, echo=FALSE--------------------------------
plot.airt.2011 <- ggplot(harMet.daily2011, aes(date, airt))+
  geom_point(colour="darkblue", na.rm=TRUE) +
  ggtitle("Average Air Temperature\n Harvard Forest 2011")+
  scale_x_date(labels = date_format("%b %d"),
               breaks = "3 months", minor_breaks= "1 week",
               limits=c(min(NDVI.2011$Date),max=max(NDVI.2011$Date)))+
  ylab("Celcius") + xlab ("")+
  theme(legend.position = "none",
        plot.title = element_text(lineheight=.8, face="bold",size = 20),
        text = element_text(size=20))

grid.arrange(plot.airt.2011, plot2.NDVI.2011) 

grid.arrange(plot2.par.2011, plot.airt.2011, plot2.NDVI.2011) 

## ----plot-same-x-axis-1--------------------------------------------------
library(reshape2)  #allows us to "melt" dataframes from "wide" to "long"

#merge the two data frames by date and retain all 'harMet.daily
harMetNDVIall.daily.2011<- merge(harMet.daily2011, 
                                 NDVI.2011, by.x = "date", 
                                 by.y = "Date", all.x=TRUE)

#convert from "wide" form to "long" form
harMetNDVI.daily.2011.long<-melt(harMetNDVIall.daily.2011, id ="date")

## ----plot-same-x-axis-2--------------------------------------------------
#subset to retain just the variables of interest.  The vertical bar character
# means "OR".
harMetNDVI.daily.2011.select<-subset(harMetNDVI.daily.2011.long,
                                variable=="meanNDVI"| variable== "prec"|
                                variable == "airt" | variable == "part")

NDVI.harMet.facet.plot<-ggplot(
  harMetNDVI.daily.2011.select,
  aes(date, value), group=variable) +
  geom_point() +
  facet_grid(variable~., scales="free") +   #specify facets & y-axis can vary
  ggtitle("Harvard Forest 2011") +
  scale_x_date(labels = date_format("%b %d"),  #abbreviated month & day
               breaks = "3 months", minor_breaks= "1 month") +  #where grid is
  xlab ("Date") + ylab ("Value") +
  theme(legend.position = "none",
        plot.title = element_text(lineheight=.8, face="bold",size = 20),
        text = element_text(size=10)
  ) 

NDVI.harMet.facet.plot


