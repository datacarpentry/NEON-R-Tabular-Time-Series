## ----basic-plotting------------------------------------------------------
#Remember it is good coding technique to add additional libraries to the top of your script (we started this section in Lesson 02)
library (ggplot2)  #for creating graphs
library (scales)   #to access breaks/formatting functions

#plot Air Temperature Data across 2009-2011 using 15-minute data
AirTemp15 <- ggplot(harMet15.09.11, aes(datetime, airt)) +
           geom_point(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                      # that 2 NA values were removed.
           ggtitle("Air Temperature At Harvard Forest (15 min. interval)") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Air Temperature (C)")
AirTemp15

## ----nice-x-axis---------------------------------------------------------
#format x axis with dates
AirTemp15 + scale_x_datetime(labels=date_format ("%m/%d/%y") )

## ----challenge-2-code----------------------------------------------------
Date<-as.Date(harMetDaily.09.11$date)  #code needs format Date not POSIX, why?

PrecipDaily <- ggplot(harMetDaily.09.11, aes(Date, prec)) +
           geom_point() +
           ggtitle("Daily Precipitation at Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",
                 size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Precipitation (mm)") +
          scale_x_date(labels=date_format ("%d/%m/%y"))

PrecipDaily

## ----load-dplyr----------------------------------------------------------
library (dplyr)   #aid with manipulating data

## ----dplyr-group---------------------------------------------------------
harMet15.09.11 %>%
  group_by(julian) %>%
  tally()

## ----simple-math---------------------------------------------------------
3*24*4  # 3 years * 24 hours/day * 4 15-min data points/hour

## ----dplyr-summarize-----------------------------------------------------
harMet15.09.11 %>%
  group_by(julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))  

## ----dplyr-lubridate-----------------------------------------------------
harMet15.09.11$year <- year(as.Date(harMet15.09.11$datetime, "%y-%b-%d",
      tz = "America/New_York"))

## ----dplyr-lubridate-2---------------------------------------------------
harMet15.09.11$year <- year(harMet15.09.11$datetime)

#check to make sure it worked
names(harMet15.09.11)

## ----dplyr-2-groups------------------------------------------------------
harMet15.09.11 %>%
  group_by(year, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

## ----dplyr-mutate--------------------------------------------------------
harMet15.09.11 %>%
  mutate(year2 = year(datetime)) %>%
  group_by(year2, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

names(harMet15.09.11)


## ----dplyr-dataframe-----------------------------------------------------
temp.daily.09.11 <- harMet15.09.11 %>%
  mutate(year3 = year(datetime)) %>%
  group_by(year3, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

names(temp.daily.09.11)

## ----challenge-3-code----------------------------------------------------
temp.monthly.09.11 <- harMet15.09.11 %>%
  mutate(month = month(datetime), year= year(datetime)) %>%
  group_by(month, year) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

str(temp.monthly.09.11)

## ----plot-airtempDaily---------------------------------------------------
AirTempDaily <- ggplot(temp.daily.09.11, aes(datetime, mean_airt)) +
           geom_point() +
           ggtitle("Average Daily Air Temperature At Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Air Temperature (C)")+
           scale_x_datetime(labels=date_format ("%d/%m/%y"))
AirTempDaily 

## ----plot-airtemp-Monthly------------------------------------------------
AirTempMonthly <- ggplot(temp.monthly.09.11, aes(datetime, mean_airt)) +
           geom_point() +
           ggtitle("Average Monthly Air Temperature At Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Date") + ylab("Air Temperature (C)")
AirTempMonthly


## ----airTemp-plots-compare-----------------------------------------------
require(gridExtra)
grid.arrange(AirTemp15, AirTempDaily, AirTempMonthly, ncol=3)

## ----challenge-4-code----------------------------------------------------

prec.monthly <- harMet15 %>%
  mutate(month = month(datetime), year= year(datetime)) %>%
  group_by(month, year) %>%
  summarize(total_prec = sum(prec, na.rm = TRUE), datetime=first(datetime))

str(prec.monthly)

PrecipMonthly <- ggplot(prec.monthly,aes(month, total_prec)) +
  geom_point(na.rm=TRUE) +
  ggtitle("Monthly Precipitation in Harvard Forest (2005 to 2011") +
  theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
  theme(text = element_text(size=20)) +
  xlab("Month") + ylab("Precipitation (mm)") 

PrecipMonthly

