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

#Inelegant and not working
winter<-harMet.daily%>%      
mutate(month=format(date, "%m")) %>%
  subset(month == 12 )

summer<-harMet.daily%>%      
mutate(month=format(date, "%m")) %>%
  subset(month==c(06,07,08))




## ----plot-by-season------------------------------------------------------

#part.prec + facet_grid(. ~ season)
#part.prec + facet_grid(season ~ .)

#part.prect + facet_wrap(~season, ncol = 2)


