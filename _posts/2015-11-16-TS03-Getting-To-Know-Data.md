---
layout: post
title: "Lesson 03: Getting to Know The Data"
date:   2015-10-22
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Michael Patterson]
dateCreated: 2015-10-22
lastModified: 2015-11-16
tags: [module-1]
description: "This lesson will teach individuals how to conduct basic data manipulation and create basic plots of time series data."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
comments: false
---

{% include _toc.html %}


##About
This activity will walk you through the fundamentals of data manipulation and 
basic plotting.

<div id="objectives" markdown="1">

**R Skill Level:** Intermediate - you've got the basics of `R` down.

### Goals / Objectives
After completing this activity, you will know:
 * How to create basic time series plots in `R`
 * How to manipulate data in `R`


###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and preferably
R studio to write your code.

####R Libraries to Install
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>
<li><strong>ggplot2:</strong> <code> install.packages("ggplot2")</code></li>
<li><strong>scales:</strong> <code> install.packages("scales")</code></li>
<li><strong>gridExtra:</strong> <code> install.packages("gridExtra")</code></li>
<li><strong>dplyr:</strong> <code> install.packages("dplyr")</code></li>

####Data to Download
Make sure you have downloaded the AtmosData folder from
http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068

####Recommended Pre-Lesson Reading
Lessons 00-02 in this Time Series learning module

</div>


NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").
{: .notice}

#Lesson 03: Getting to Know The Data
As we continue working with our data we are going to learn skills that
will enable us to visualize our data by:
1) plotting the 15-minute air temperature data across years,
2) manipulating the date to group and summarize by year, daily average, and 
julian date, and 
3) compareing plots of 15-minute and daily average air temperature. 

##Plotting Time Series Data
One of the first things that can often be useful once we've loaded our 
data and cleaned it up is to visualize it. We can start to get a sense of 
general trends, as well as see possible outliers or non-sensical values. 

To do this, we're going to use the package `ggplot2` to plot the air temperature across our 3 year time span for each 15 minute data point. We will not cover the details of how to use ggplot to customize your plot, but some of these will be introduced in the last module: Making Pretty Maps.


    #Remember it is good coding technique to add additional libraries to the top of
      #your script (we started this section in Lesson 02)
    library (ggplot2)  #for creating graphs
    library (scales)   #to access breaks/formatting functions
    
    #plot Air Temperature Data across 2009-2011 using 15-minute data
    AirTemp15a <- ggplot(harMet15.09.11, aes(datetime, airt)) +
               geom_point(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                          # that 2 NA values were removed.
               ggtitle("15 min Air Temperature At Harvard Forest") +
               theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Date") + ylab("Air Temperature (C)")
    AirTemp15a

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/basic-plotting-1.png) 

Here we see that we get a warning message saying that two rows were removed due
to missing values.  Those are the two rows that still had NA in the air
temperature data.  

The dates on the x-axis are unreadable and not particularly well formatted. We 
can reformat them so they are in the Month/Day/Year format we are used to. 

    #format x axis with dates
    AirTemp15<-AirTemp15a + scale_x_datetime(labels=date_format ("%m/%d/%y") )
    AirTemp15

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/nice-x-axis-1.png) 

Bonus: If an x variable is not a datetime class (e.g., not POSIX), other 
`scale_x_...()` exist to help format x axes. 

##Challenge 2: Plotting daily precipitaiton data
Using the daily precipitation data you imported earlier, create a plot with the
x-axis in a European Format (Day/Month/Year).  For ease in future activities 
name the plot 'PrecipDaily".


    PrecipDaily <- ggplot(harMetDaily.09.11, aes(date, prec)) +
               geom_point() +
               ggtitle("Daily Precipitation at Harvard Forest") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Date") + ylab("Precipitation (mm)") +
              scale_x_datetime(labels=date_format ("%d/%m/%y"))
    
    PrecipDaily

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/challenge-2-code-1.png) 

We will return to precipitation data in Challenge 4 and discuss this plot. 

##Manipulating Data using `dplyr`
Looking back at the 15 minute air temperature plot, the data are interesting and
we can, unsurprisingly, see a clear seasonal trend. Yet the air temperature data
at 15 minute intervals is at a finer time-step than we want. Instead, we  want to 
look at how daily average temperature changes over time. To do this we first 
need to learn a bit about how to manipulate data in R. We'll use the `dplyr` 
package. 


    library (dplyr)   #aid with manipulating data #remember it is good coing practice to load all packages at the beginning of your script

    ## 
    ## Attaching package: 'dplyr'
    ## 
    ## The following objects are masked from 'package:lubridate':
    ## 
    ##     intersect, setdiff, union
    ## 
    ## The following objects are masked from 'package:stats':
    ## 
    ##     filter, lag
    ## 
    ## The following objects are masked from 'package:base':
    ## 
    ##     intersect, setdiff, setequal, union

The `dplyr` package is designed to simplify more complicated data manipulations
in dataframes.  Beyond what we are focusing on today, it is also useful
for manipulating data stored in an external database. This is especially useful
to know about if you will be working with very large datasets or relational 
databases in the future. 

If you are interested in learning more about `dplyr` after this lesson consider
following up with `dplyr` lessons from 

1) [NEON Data Skills] (http://neondataskills.org/R/GREPL-Filter-Piping-in-DPLYR-Using-R/) or 

2) [Data Carpentry] (http://www.datacarpentry.org/R-ecology/04-dplyr.html)

and reading the CRAN `dplyr` package [description] (https://cran.r-project.org/web/packages/dplyr/dplyr.pdf).

For the purposes of our data in the Harvard Forest we want to be able to split
our larger dataset into groups (e.g., by year), then manipulate each of the
smaller groups (e.g., take the average) before bringing them back together as a
whole (e.g., to plot the data). This is called using the "split-apply-combine"
technique, for which `dplyr` is particularly useful. 

### Grouping by a varaible (or two)
Getting back to our basic question of understanding annual phenology patterns, we 
would like to look at the daily average temperature throughout the year.  We 
plotted the 15 minute data across the three years earlier in this lesson, 
however, now we'd like to look at the average temperature on a specific day for
all three years. To do this we can use the `group-by()` function. 

Before getting into our data, let's count up the number of observations per
Julian date using the `group-by()` function to determine how we split up our
data. Remember we created a column named "julian" for our Julian Day data.


    harMet15.09.11 %>%          #Within the harMet15.09.11 data
      group_by(julian) %>%      #group the data by the julian day
      tally()                   #and tally how many observations per julian day

    ## Error in eval(expr, envir, enclos): unknown column 'julian'

The `%>%` at the end of the lines are 'pipes', pipes are an important tool in
`dplyr` that allow us to skip creating and naming intermediate steps. Pipes,
like the name implies, allow us to take the output of one function and send
(pipe) it directly to the next function. We don't have to save the intermediate
steps between functions. The above code essentially says: go into the
harMet15.09.11 dataframe, find the julian dates, group them, and then count
(tally) how many values for each of the grouped days.  

Bonus: Older `dplyr` coded pipes as %.% and you may still see that format in some
older Stack Overflow answers and other tutuorials. 

As the output shows we have 288 values for each day.  Is that what we expect? 


    3*24*4  # 3 years * 24 hours/day * 4 15-min data points/hour

    ## [1] 288

Yep!  Looks good. 

Now that we've learned about pipes, let's use them to calculate what we are more
interested in, calculating daily average values by julian day. We can use the
`summarize()` function for this. `summarize()` will collapse each group (e.g.,
julian day) and output the group value for whatever function (e.g., mean) we 
specify. 

We can use the pipes to get the mean air temperature for each julian day. Since
we know we have a few missing values we can add `na.rm=TRUE` to force R to ignore
any NA values when making the calculations. 


    harMet15.09.11 %>%
      group_by(julian) %>%
      summarize(mean_airt = mean(airt, na.rm = TRUE))  

    ## Error in eval(expr, envir, enclos): unknown column 'julian'

Julian days repeat 1-365 (or 366) each year, therefore what we have here is that
the mean temperature for all 3 January 1st in 2009, 2010, and 2011 was -3.7C. 
Sometimes this is how we want to summarize our data, however, we may also want 
to summarize our air temperature data for each day in each of the three years.  
To do that we need to group our data by two different values at once, year and 
julian day. 

### Extracting year data from a date & time variable
Currently our date and time information is in one column (datetime) but to group
by year, we're first going to need to create a year-only variable. 

For this we'll again use the `lubridate` package:


    harMet15.09.11$year <- year(as.Date(harMet15.09.11$datetime, "%y-%b-%d",
          tz = "America/New_York"))

or since our date data is already a POSIX date/time variable, we can be more efficient: 


    harMet15.09.11$year <- year(harMet15.09.11$datetime)

Using `names()` we can see that we now have a variable named year. Here we are specifying the last column we added (32).

    #check to make sure it worked
    names(harMet15.09.11 [32])

    ## Error in `[.data.frame`(harMet15.09.11, 32): undefined columns selected

Now we have our two variables: julian and year. To get the mean air temperature
for each day for each year we can use the `dplyr` pipes to group by year and
julian date.


    harMet15.09.11 %>%
      group_by(year, julian) %>%
      summarize(mean_airt = mean(airt, na.rm = TRUE))

    ## Error in eval(expr, envir, enclos): unknown column 'julian'

Given just the header in the output we can see the difference between the
3 year average temperature for 1 January (-3.7C) and the average temperature for
1 January 2009 (-15.1C).

###Combining functions to increase efficiency
To create more efficient code, could we create the year variable within our
`dplyr` function call? 

Yes, we can use the `mutate()` function of `dplyr` and include our `lubridate`
function within the `mutate()` call. `mutate()` is used to add new data to a
dataframe. These are often new data that are created from a calculation or
manipulation of existing data. If you are familiar with the `tranform()` core R
function the usage is similar:  `mutate()` allows us to create and immediately use a
variable (year2), which is something that the core `R` function `transform()`
will not do.


    harMet15.09.11 %>%
      mutate(year2 = year(datetime)) %>%
      group_by(year2, julian) %>%
      summarize(mean_airt = mean(airt, na.rm = TRUE))

    ## Error in eval(expr, envir, enclos): unknown column 'julian'

For illustration purposes, we named the new variable we were creating with
`mutate()` year2 so we could distinguish it from the year already created by
`year()`. Notice that after using this code, we don't see year2 as a column
in our harMet15.09.11 dataframe.  

    names(harMet15.09.11)

    ##  [1] "datetime" "jd"       "airt"     "f.airt"   "rh"       "f.rh"    
    ##  [7] "dewp"     "f.dewp"   "prec"     "f.prec"   "slrr"     "f.slrr"  
    ## [13] "parr"     "f.parr"   "netr"     "f.netr"   "bar"      "f.bar"   
    ## [19] "wspd"     "f.wspd"   "wres"     "f.wres"   "wdir"     "f.wdir"  
    ## [25] "wdev"     "f.wdev"   "gspd"     "f.gspd"   "s10t"     "f.s10t"  
    ## [31] "year"

We want to save this information so that we can plot the daily air temperature
as well. So, we save the output of our dplyr function as a new data frame. 

What additional variables do we want for our plots? 
In order to have nicely formatted x-axis we need to retain the datetime
information. But we only want one datetime entry per air temperature measurement.
We can get this by asking R to output the first datetime entry for each day for
each year using the `summarize()` function.


    temp.daily.09.11 <- harMet15.09.11 %>%
      mutate(year3 = year(datetime)) %>%
      group_by(year3, julian) %>%
      summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))

    ## Error in eval(expr, envir, enclos): unknown column 'julian'

    str(temp.daily.09.11)

    ## Error in str(temp.daily.09.11): object 'temp.daily.09.11' not found

Now we have a dataframe with only values for Year, Julian Day, Mean Air Temp,
and a Date. 

##Challenge 3: Applying `dplyr` Skills
Calculate and save a dataframe of the average air temperate for each month in
each year.  For ease with future activities name your new dataframe
"temp.monthly.09.11"


    temp.monthly.09.11 <- harMet15.09.11 %>%
      mutate(month = month(datetime), year= year(datetime)) %>%
      group_by(month, year) %>%
      summarize(mean_airt = mean(airt, na.rm = TRUE), datetime = first(datetime))
    
    str(temp.monthly.09.11)

    ## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	36 obs. of  4 variables:
    ##  $ month    : num  1 1 1 2 2 2 3 3 3 4 ...
    ##  $ year     : num  2009 2010 2011 2009 2010 ...
    ##  $ mean_airt: num  -8.24 -4.83 -6.51 -2.88 -3.29 ...
    ##  $ datetime : POSIXct, format: "2009-01-01" "2010-01-01" ...
    ##  - attr(*, "vars")=List of 1
    ##   ..$ : symbol month
    ##  - attr(*, "drop")= logi TRUE


## Plotting daily & monthly temperature data
Now that we have daily and monthly air temperature data (temp.daily.09.11 &
temp.monthly.09.11 dataframes), let's plot the average daily temperature.  

    AirTempDaily <- ggplot(temp.daily.09.11, aes(datetime, mean_airt)) +
               geom_point() +
               ggtitle("Average Daily Air Temperature At Harvard Forest") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                      size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Date") + ylab("Air Temperature (C)")+
               scale_x_datetime(labels=date_format ("%d%b%y"))

    ## Error in ggplot(temp.daily.09.11, aes(datetime, mean_airt)): object 'temp.daily.09.11' not found

    AirTempDaily 

    ## Error in eval(expr, envir, enclos): object 'AirTempDaily' not found

Notice in the code for the x scale (`scale_x_datetime()`), we changed the date format from %m to %b which gives the abreviated month.

Now that we've plotted daily temperature together, plot the monthly on your own
before looking at the next set of code. If you get stuck, suggested code is
below.  For ease of future code, name your plot "AirTempMonthly".


    AirTempMonthly <- ggplot(temp.monthly.09.11, aes(datetime, mean_airt)) +
               geom_point() +
               ggtitle("Average Monthly Air Temperature At Harvard Forest") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                    size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Date") + ylab("Air Temperature (C)") +
              scale_x_datetime(labels=date_format ("%b%y"))
    AirTempMonthly

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/plot-airtemp-Monthly-1.png) 

Notice in the code for the x scale (`scale_x_datetime()`), we further changed
the date format by removing the day since we are graphing monthly averages. 

Lets compare the two air tempurature figures we have created. Unfortunately
`ggplot` doesn't recognize `par(mfrow=())` to show side by side figures.
Instead we can use another package, `gridExtra`, to do this. 


    require(gridExtra)

    ## Loading required package: gridExtra

    grid.arrange(AirTemp15, AirTempDaily, AirTempMonthly, ncol=1)

    ## Error in arrangeGrob(...): object 'AirTempDaily' not found

On which plot is it easier to see annual patterns of air temperature?  Can you
think of when you might use one plot or another?  Remember if the plots are too
small you can use the zoom feature in R Studio to pop the out into a seperate
window.  

##Challenge 4: Combining `dplyr` and `ggplot` Skills
Plot the precipiation by month in all years available. 

Using the Harvard Meterorological 15-min datafile, plot the average monthly 
precipitation using all years (not just 09-11).  Does it make more sense to
calculate the total precipitation for each month or the average percipitation
for each month?


    prec.monthly <- harMet15 %>%
      mutate(month = month(datetime), year= year(datetime)) %>%
      group_by(month, year) %>%
      summarize(total_prec = sum(prec, na.rm = TRUE), datetime=first(datetime))
    
    str(prec.monthly)

    ## Classes 'grouped_df', 'tbl_df', 'tbl' and 'data.frame':	129 obs. of  4 variables:
    ##  $ month     : num  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ year      : num  2005 2006 2007 2008 2009 ...
    ##  $ total_prec: num  120.5 110 82.9 75.7 84.4 ...
    ##  $ datetime  : chr  "2005-01-01T00:15" "2006-01-01T00:15" "2007-01-01T00:15" "2008-01-01T00:15" ...
    ##  - attr(*, "vars")=List of 1
    ##   ..$ : symbol month
    ##  - attr(*, "drop")= logi TRUE

    PrecipMonthly <- ggplot(prec.monthly,aes(month, total_prec)) +
      geom_point(na.rm=TRUE) +
      ggtitle("Monthly Precipitation in Harvard Forest (2005-2011") +
      theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
      theme(text = element_text(size=20)) +
      xlab("Month") + ylab("Precipitation (mm)") +
      scale_x_discrete(labels=month)  
    #month is no longer datetime, but a discrete number. Change from scale_x_datetime()
      #to scale_x_discrete()
    
    PrecipMonthly

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/challenge-4-code-1.png) 

    #If we want written out month labels
    PrecipMonthly + scale_x_discrete("month", labels = c("1" = "Jan","2" = "Feb",
      "3" = "Mar","4" = "Apr","5" = "May","6" = "Jun","7" = "Jul","8" = "Aug","9" = "Sep","10" = "Oct","11" = "Nov","12" = "Dec") )

    ## Scale for 'x' is already present. Adding another scale for 'x', which will replace the existing scale.

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/challenge-4-code-2.png) 

Is there an obvious annual trend in percipitation at Harvard Forest?  

Compare how you plotted daily (Challenge 2: DailyPrecip) and monthly
precipitation (Challenge 4: PrecipMontly). When would one format be better than 
another? 


    grid.arrange(PrecipDaily, PrecipMonthly, ncol=1)

![ ]({{ site.baseurl }}/images/rfigs/TS03-Getting-To-Know-Data/compare-precip-1.png) 

In the next lesson we will learn to expand our plotting abilities to plot two
variables side-by-side and to incorporate values from spacial data sets (NDVI)
into our phenology related plots. 
