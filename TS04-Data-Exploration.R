## ----PAR-v-precip--------------------------------------------------------
#PAR v precip 
par.precip <- ggplot(harMet.daily,aes(prec, part)) +
           geom_point(na.rm=TRUE) +    #removing the NA values
           ggtitle("Daily Precipitation and PAR at Harvard Forest") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Total Precipitation (mm)") + ylab("Mean Total PAR")
par.precip

## ----subsetting-by-season------------------------------------------------
#subset by season using month (12-2 is winter, 3-5 spring, 6-8 summer, 9-11 fall)
#add month column
harMet.daily <- harMet.daily  %>% 
  mutate(month=format(date,"%m"))

#check structure of this variable
str(harMet.daily$month)

#notice it is a character

#use mutate to create a new variable for season, because month is a character variable we need to put the month number in quotes in this formula
# %in% is short-hand for OR, so the 3rd line of code essentially says "If the month variable is equal to 12 or to 01 or to 02, set the season variable to winter.
harMet.daily <- harMet.daily %>% 
  mutate(season = 
           ifelse(month %in% c("12", "01", "02"), "winter",
           ifelse(month %in% c("03", "04", "05"), "spring",
           ifelse(month %in% c("06", "07", "08"), "summer",
           ifelse(month %in% c("09", "10", "11"), "fall", "Error")))))

#check to see if this worked
head(harMet.daily)
tail(harMet.daily)


## ----plot-by-season------------------------------------------------------

#run this code to plot the same plot as before but with one plot per season
par.precip + facet_grid(. ~ season)

## ----create-new-par.precip-----------------------------------------------
#need to add code

## ----plot-by-season2-----------------------------------------------------
par.precip + facet_grid(. ~ season)
# for a landscape orientation of the plots:
par.precip + facet_grid(season ~ .)
#and another arrangementt of plots:
par.precip + facet_wrap(~season, ncol = 2)


## ----NDVI plots----------------------------------------------------------
#first read in the NDVI CSV data
NDVI.2009 <- read.csv(file="Landsat_NDVI/Harv2009NDVI.csv", stringsAsFactors = FALSE)
#check out the data
str(NDVI.2009)
View(NDVI.2009)

###plot of NDVI vs. PAR using daily data
#first lets get just 2009 from the harmet.Daily data since that is the only year for which we have NDVI data
harMet.daily2009 <- harMet.daily %>% 
  mutate(year = year(date)) %>%   #need to create a year only column first
  filter(year == "2009")

#ggplot does not provide for two y-axes and the scale for these two variables are vastly different.
#So we will create a plot for each variable using the same time variable (julian day) as our x-axis.
#Then we will plot the two plots in the same viewer so we can compare

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

#Let's take a look at air temperature too
airt.2009 <- ggplot(harMet.daily2009, aes(jd,airt))+
  geom_point(na.rm=TRUE)+
  ggtitle("Daily Air Temperature at Harvard Forest, 2009")+
  theme(legend.position = "none", plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) 

grid.arrange(airt.2009, NDVI.2009)
#all 3 together
grid.arrange(par.2009, airt.2009, NDVI.2009)


