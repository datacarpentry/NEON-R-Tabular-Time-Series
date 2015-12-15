## ----load-data-----------------------------------------------------------
#Remember it is good coding technique to add additional packages to the top of
  #your script 
library(lubridate) #for working with dates
library(dplyr)    #for data manipulation (split, apply, combine)

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

#15-min Harvard Forest met data, 2009-2011
harMet15.09.11<- read.csv(file="AtmosData/HARV/Met_HARV_15min_2009_2011.csv",
                          stringsAsFactors = FALSE)
#convert datetime to POSIXct
harMet15.09.11$datetime<-as.POSIXct(harMet15.09.11$datetime,
                    format = "%Y-%m-%d %H:%M",
                    tz = "America/New_York")

## ----15-min-plots, echo=FALSE--------------------------------------------
library(gridExtra)

temp=qplot(x=datetime, y=airt, 
           data=harMet15.09.11, na.rm=TRUE,
           main=("Air Temp \n Harvard Forest"),
           xlab="Date", ylab= "Air Temp, Celcius")

prec=qplot(x=datetime, y=prec, 
           data=harMet15.09.11, na.rm=TRUE,
           main=("Precipitation \n Harvard Forest"),
           xlab="Date", ylab= "Daily Total Precip., mm")

PAR=qplot(x=datetime, y=parr, 
           data=harMet15.09.11, na.rm=TRUE,
           main=("Air Temp \n Harvard Forest"),
           xlab="Date", ylab= "Total PAR-Daily Mean")

grid.arrange(temp, prec, PAR, ncol=3)

## ----pipe-demo, eval=FALSE-----------------------------------------------
## harMet15.09.11 %>%      #Within the harMet15.09.11 data
##   group_by(jd) %>%      #group the data by the Julian day
##   tally()               #and tally how many observations per julian day

## ----dplyr-group---------------------------------------------------------
harMet15.09.11 %>%      #Within the harMet15.09.11 data
  group_by(jd) %>%      #group the data by the Julian day
  tally()               #and tally how many observations per julian day

## ----simple-math---------------------------------------------------------
3*24*4  # 3 years * 24 hours/day * 4 15-min data points/hour

## ----dplyr-summarize-----------------------------------------------------
harMet15.09.11 %>%
  group_by(jd) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))  

## ----dplyr-lubridate-2---------------------------------------------------
harMet15.09.11$year <- year(harMet15.09.11$datetime)

## ----dplyr-lubridate-3---------------------------------------------------
#check to make sure it worked
names(harMet15.09.11)
str(harMet15.09.11$year)

## ----dplyr-2-groups------------------------------------------------------
harMet15.09.11 %>%
  group_by(year, jd) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

## ----dplyr-mutate--------------------------------------------------------
harMet15.09.11 %>%
  mutate(year2 = year(datetime)) %>%
  group_by(year2, jd) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))


## ----dplyr-mutate-2------------------------------------------------------
names(harMet15.09.11)

## ----dplyr-create-data-frame---------------------------------------------
harTemp.daily.09.11<-harMet15.09.11 %>%
                    mutate(year2 = year(datetime)) %>%
                    group_by(year2, jd) %>%
                    summarize(mean_airt = mean(airt, na.rm = TRUE))

head(harTemp.daily.09.11)

## ----dplyr-dataframe-----------------------------------------------------
harTemp.daily.09.11 <- harMet15.09.11 %>%
  mutate(year3 = year(datetime)) %>%
  group_by(year3, jd) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

str(harTemp.daily.09.11)

## ----challenge-code-dplyr, include=TRUE, results="hide", echo=FALSE------
harTemp.monthly.09.11 <- harMet15.09.11 %>%
  mutate(month = month(datetime), year= year(datetime)) %>%
  group_by(month, year) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

str(harTemp.monthly.09.11)

