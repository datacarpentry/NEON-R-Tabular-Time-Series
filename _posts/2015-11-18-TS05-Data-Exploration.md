---
layout: post
title: "Lesson 04: Data Exploration"
date:   2015-10-21
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah Wasser]
dateCreated: 2015-10-22
lastModified: 2015-11-18
category:  
tags: [module-1]
mainTag: 
description: "This lesson will teach individuals how to plot subsetted timeseries data (e.g., plot by season) and to plot time series data with NDVI."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Data-Exploration
comments: false
---

{% include _toc.html %}

##About
This lesson will teach individuals how to plot subsetted timeseries data (e.g., plot by season) and to plot time series data with NDVI.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:
 * Know how to use facets in ggplot,
 * Be able to combine different types of data into one plot.

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and, preferably,
RStudio to write your code.

####R Libraries to Install
<li><strong>ggplot:</strong> <code> install.packages("ggplot2")</code></li>
<li><strong>scales:</strong> <code> install.packages("scales")</code></li>
<li><strong>gridExtra:</strong> <code> install.packages("gridExtra")</code></li>

####Data to Download
Make sure you have downloaded the Landsat_NDVI folder from
http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068

####Recommended Pre-Lesson Reading
Lessons 00-03 in this Time Series learning module

</div>


NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").
{: .notice}

#Lesson 04: Further Exploration of the Data
Up until this point in the lesson we have been looking at how a single variable 
changes across time. In the interest of studying phenology it is likely that 
some combination of precipitation, temperature, and solar radiation (PAR) plays
a role in the annual greening and browning of plants.  

Let's look at interactions between several of the variables to each other across
the seasons before adding the NDVI data into the mix.  Using the NDVI data we
can finally directly compare the observed plant phenology with patterns we've 
already been exploring.  

All the packages we need in this lesson were loaded in previous lessons
00-03, the code is not included here.  {: .notice}

##Graph precip by total PAR across all seasons
PAR, a measure of solar radiation, is less on cloudy days and precipitation is
also more likely when clouds are present.  We will use `ggplot` to graph PAR
and precipitation from the daily Harvard Meterological data.  We can simply do
this using the code we previously learned and substituting precipitation
(prec) in for time on the x axis.  


    #PAR v precip 
    par.precip <- ggplot(harMet.daily,aes(prec, part)) +
               geom_point(na.rm=TRUE) +    #removing the NA values
               ggtitle("Daily Precipitation and PAR at Harvard Forest") +
               theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Total Precipitation (mm)") + ylab("Mean Total PAR")
    par.precip

![ ]({{ site.baseurl }}/images/rfigs/TS05-Data-Exploration/PAR-v-precip-1.png) 

While there is a lot of noise in the data, there does seem to be a trend of 
lower PAR when precipitation is high. Yet in this data we don't tease apart any 
of annual patterns as date isn't any part of this figure.  

##Use daily data and subset by seasons (retaining PAR, precip, & temp variables)
One way to add a time component to this figure is to subset the data by season 
and then to plot a facetted graph showing the data by season.  

The first step to doing this is to subset by season.  First, we have to switch 
away from coding and data analysis and think about ecology.  What is the best
way to break a year apart into seasons?  

The divisions will change depending on the geographic location and climate where the
data were collected.  We are using data from Harvard Forest in Massachusetts in
in the northeastern United States.  Given the strong seasonal affects in this 
area dividing the year into 4 seasons is ecologically relevant.  Based on
general knowledge of the area it is also plausible to group the months as 

 * Winter: December - February
 * Spring: March - May 
 * Summer: June - August
 * Fall: September - November 
 
In order to subset the data by season we will again use the `dplyr` package.


    #subset by season using month (12-2 is winter, 3-5 spring, 6-8 summer, 9-11 fall)
    #add month column
    harMet.daily <- harMet.daily  %>% 
      mutate(month=format(date,"%m"))
    
    #check structure of this variable
    str(harMet.daily$month)

    ##  chr [1:5345] "02" "02" "02" "02" "02" "02" "02" "02" ...

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

    ##         date jd  airt f.airt airtmax f.airtmax airtmin f.airtmin rh f.rh
    ## 1 2001-02-11 42 -10.7           -6.9             -15.1           40     
    ## 2 2001-02-12 43  -9.8           -2.4             -17.4           45     
    ## 3 2001-02-13 44  -2.0            5.7              -7.3           70     
    ## 4 2001-02-14 45  -0.5            1.9              -5.7           78     
    ## 5 2001-02-15 46  -0.4            2.4              -5.7           69     
    ## 6 2001-02-16 47  -3.0            1.3              -9.0           82     
    ##   rhmax f.rhmax rhmin f.rhmin  dewp f.dewp dewpmax f.dewpmax dewpmin
    ## 1    58            22         -22.2          -16.8             -25.7
    ## 2    85            14         -20.7           -9.2             -27.9
    ## 3   100            34          -7.6           -4.6             -10.2
    ## 4   100            59          -4.1            1.9             -10.2
    ## 5   100            37          -6.0            2.0             -12.1
    ## 6   100            46          -5.9           -0.4             -10.6
    ##   f.dewpmin prec f.prec slrt f.slrt part f.part netr f.netr  bar f.bar
    ## 1            0.0        14.9          NA      M   NA      M 1025      
    ## 2            0.0        14.8          NA      M   NA      M 1033      
    ## 3            0.0        14.8          NA      M   NA      M 1024      
    ## 4            6.9         2.6          NA      M   NA      M 1016      
    ## 5            0.0        10.5          NA      M   NA      M 1010      
    ## 6            2.3         6.4          NA      M   NA      M 1016      
    ##   wspd f.wspd wres f.wres wdir f.wdir wdev f.wdev gspd f.gspd s10t f.s10t
    ## 1  3.3         2.9         287          27        15.4          NA      M
    ## 2  1.7         0.9         245          55         7.2          NA      M
    ## 3  1.7         0.9         278          53         9.6          NA      M
    ## 4  2.5         1.9         197          38        11.2          NA      M
    ## 5  1.6         1.2         300          40        12.7          NA      M
    ## 6  1.1         0.5         182          56         5.8          NA      M
    ##   s10tmax f.s10tmax s10tmin f.s10tmin month season
    ## 1      NA         M      NA         M    02 winter
    ## 2      NA         M      NA         M    02 winter
    ## 3      NA         M      NA         M    02 winter
    ## 4      NA         M      NA         M    02 winter
    ## 5      NA         M      NA         M    02 winter
    ## 6      NA         M      NA         M    02 winter

    tail(harMet.daily)

    ##            date  jd airt f.airt airtmax f.airtmax airtmin f.airtmin rh
    ## 5340 2015-09-25 268 13.2           19.2               9.6           76
    ## 5341 2015-09-26 269 11.0           17.0               5.5           74
    ## 5342 2015-09-27 270 11.4           20.5               3.3           72
    ## 5343 2015-09-28 271 16.9           23.0              11.3           85
    ## 5344 2015-09-29 272 20.1           24.6              17.1           91
    ## 5345 2015-09-30 273 17.1           21.9               9.0           94
    ##      f.rh rhmax f.rhmax rhmin f.rhmin dewp f.dewp dewpmax f.dewpmax
    ## 5340         92            52          8.9           12.2          
    ## 5341         96            42          6.0            8.8          
    ## 5342         96            24          5.6           11.0          
    ## 5343         97            60         14.2           16.8          
    ## 5344         97            73         18.5           21.0          
    ## 5345         97            87         16.1           21.4          
    ##      dewpmin f.dewpmin prec f.prec slrt f.slrt part f.part netr f.netr
    ## 5340     5.1            0.0        15.8        32.6        62.5       
    ## 5341     3.4            0.0        18.1        36.4        71.7       
    ## 5342    -1.1            0.0        19.6        39.1        75.5       
    ## 5343    10.5            0.0        14.4        28.7        74.0       
    ## 5344    16.2           11.9         8.3        16.2        38.4       
    ## 5345     7.1           76.2         3.6         6.6         3.1       
    ##       bar f.bar wspd f.wspd wres f.wres wdir f.wdir wdev f.wdev gspd
    ## 5340 1029        1.3         1.1          74          37         6.9
    ## 5341 1031        1.4         1.2          78          31         7.9
    ## 5342 1029        0.9         0.2         165          71         4.2
    ## 5343 1024        1.2         0.9         196          36         6.8
    ## 5344 1018        1.5         1.3         189          31         7.1
    ## 5345 1011        1.7         0.2          13          74        11.7
    ##      f.gspd s10t f.s10t s10tmax f.s10tmax s10tmin f.s10tmin month season
    ## 5340        17.7           18.2              17.1              09   fall
    ## 5341        17.3           17.7              16.8              09   fall
    ## 5342        16.5           17.1              15.7              09   fall
    ## 5343        16.9           17.8              16.1              09   fall
    ## 5344        18.1           18.8              17.5              09   fall
    ## 5345        19.3           19.7              18.7              09   fall

##Use facets in ggplot
This allows us to create the same graph for each season and display them in a
grid. Also break up this chunk and move some in code directions to text. 

    #run this code to plot the same plot as before but with one plot per season
    par.precip + facet_grid(. ~ season)

    ## Error in layout_base(data, cols, drop = drop): At least one layer must contain all variables used for facetting

Why this didn't work? 
We added the season variable to harMet.daily after we created the original par.precip plot. Go back up to the code we used to create par.precip and run it again; now it will include the new version of harMet.daily that has the season variable.

    #need to add code

Let's try the original code again with the new plot. 

    par.precip + facet_grid(. ~ season)

    ## Error in layout_base(data, cols, drop = drop): At least one layer must contain all variables used for facetting

    # for a landscape orientation of the plots:
    par.precip + facet_grid(season ~ .)

    ## Error in layout_base(data, rows, drop = drop): At least one layer must contain all variables used for facetting

    #and another arrangementt of plots:
    par.precip + facet_wrap(~season, ncol = 2)

    ## Error in layout_base(data, vars, drop = drop): At least one layer must contain all variables used for facetting

#Graph variables and NDVI data together
Add discussion of why you might want to do this. 


    #first read in the NDVI CSV data
    NDVI.2009 <- read.csv(file="Landsat_NDVI/Harv2009NDVI.csv", stringsAsFactors = FALSE)

    ## Warning in file(file, "rt"): cannot open file 'Landsat_NDVI/
    ## Harv2009NDVI.csv': No such file or directory

    ## Error in file(file, "rt"): cannot open the connection

    #check out the data
    str(NDVI.2009)

    ## Error in str(NDVI.2009): object 'NDVI.2009' not found

    View(NDVI.2009)

    ## Error in View : object 'NDVI.2009' not found

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

    ## Error in ggplot(NDVI.2009, aes(julianDays, meanNDVI)): object 'NDVI.2009' not found

    #display the plots together
    grid.arrange(par.2009, NDVI.2009) 

    ## Error in arrangeGrob(...): object 'NDVI.2009' not found

    #Let's take a look at air temperature too
    airt.2009 <- ggplot(harMet.daily2009, aes(jd,airt))+
      geom_point(na.rm=TRUE)+
      ggtitle("Daily Air Temperature at Harvard Forest, 2009")+
      theme(legend.position = "none", plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
               theme(text = element_text(size=20)) 
    
    grid.arrange(airt.2009, NDVI.2009)

    ## Error in arrangeGrob(...): object 'NDVI.2009' not found

    #all 3 together
    grid.arrange(par.2009, airt.2009, NDVI.2009)

    ## Error in arrangeGrob(...): object 'NDVI.2009' not found


#Polishing your ggPlot graphs
Throughout this module we have been creating plots using ggplot.  We've covered
the basics of adding axis labels and titles but using ggplot you can do so much 
more.  If you are interested in making your graphs look better consider
following up with any of these resources:

1) ggplot2 Cheatsheet from Zev Ross: <a href="http://neondataskills.org/cheatsheets/R-GGPLOT2/" target="_blank"> ggplot2 Cheatsheet</a>  
2) ggplot2 documentation index: 
 <a href="http://docs.ggplot2.org/current/index.html#" target="_blank"> ggplot2 Documentation</a>    
3) NEON's Publishable Maps Tutorial ADD LINK TO PRETTY MAPS TUTORIAL WHEN DONE
