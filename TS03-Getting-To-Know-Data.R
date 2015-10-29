## ----basic-plotting------------------------------------------------------
#plot Some Air Temperature Data
myPlot <- ggplot(yr.09.11,aes(datetime, airt)) +
           geom_point() +
           ggtitle("15 min Avg Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

## ----nice-x-axis---------------------------------------------------------
#format x axis with dates
myPlot + scale_x_datetime(labels = date_format("%m/%d/%y"))

## ----dplyr-group---------------------------------------------------------
yr.09.11 %>%
  group_by(julian) %>%
  tally()

## ----dplyr summarize-----------------------------------------------------
yr.09.11 %>%
  group_by(julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

## ----dplyr-lubridate-----------------------------------------------------
yr.09.11$year <- year(as.Date(yr.09.11$datetime, "%y-%b-%d",
      tz = "America/New_York"))

## ----dplyr-lubridate-2---------------------------------------------------
yr.09.11$year <- year(yr.09.11$datetime)

## ----dplyr-full----------------------------------------------------------
yr.09.11 %>%
  group_by(year, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

## ----dplyr-mutate--------------------------------------------------------
yr.09.11 %>%
  mutate(year = year(datetime)) %>%
  group_by(year, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE))

## ----dplyr-saving--------------------------------------------------------
temp.daily <- yr.09.11 %>%
  mutate(year = year(datetime)) %>%
  group_by(year, julian) %>%
  summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

## ----daily-plot----------------------------------------------------------
dailyPlot <- ggplot(temp.daily,aes(datetime, mean_airt)) +
           geom_point() +
           ggtitle("Daily Avg Air Temperature\nHarvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
          theme(text = element_text(size=20)) +
           xlab("Time") + ylab("Mean Air Temperature")

#format x axis with dates
dailyPlot + scale_x_datetime(labels = date_format("%m/%d/%y"))

