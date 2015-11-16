---
layout: post
title: "Lesson 02b: Subsetting Data by Date and NoData Values in R"
date: 2015-10-23
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser]
dateCreated: 2015-10-22
lastModified: 2015-11-16
tags: module-1
description: "This lesson will teach individuals how to prepare tabular data for further analysis in R, addressing missing values and date-time formats. Students will also learn how to convert characters to a time class, to convert date-time to Julian day, and how to subset the data into a new data frame."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
comments: false
---

{% include _toc.html %}

##About
This lesson will teach students how to prepare tabular data for further analysis
in R, addressing missing values and date-time formats. Students will also learn
how to convert characters to a time class, to convert date-time to Julian day, 
and how to subset the data into a new data frame.

<div id="objectives" markdown="1">

**R Skill Level:** Intermediate - you've got the basics of `R` down and 
understand the general structure of tabular data.

### Goals / Objectives
After completing this activity, you will know how to:
 * Clean data
 * Convert/transform time formats
 * Subset data
 * Examine data structures and types

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and preferably
R studio to write your code.

####R Libraries to Install
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>

####Data to Download

<a href="http://files.figshare.com/2437700/AtmosData.zip" class="btn btn-success">
Download Atmospheric Data</a>

NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").

####Recommended Pre-Lesson Reading
Lessons 00-01 in this Time Series learning module

</div>


In this lesson, we will use functions from both base `R` and the `lubridate` 
library to work with date-time formats.

#BELOW is background  - not sure this belongs here.
NOTE: there are a few options for working with date-time formats
(readr, zoo), which are based on similar concepts, you will be able to use help
text to explore those on your own as you choose. 


    # Load packages required for entire script
    library(lubridate)  #work with dates
    library(ggplot2)  #efficient plotting
    
    
    #load data
    harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                         stringsAsFactors = FALSE)
    
    #still getting NA values when i do this conversion
    sum(is.na(harMet_15Min$datetime))

    ## [1] 0

    #convert to date-time class
    harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                    format = "%Y-%m-%dT%H:%M",
                                    tz = "America/New_York")


##Subsetting
Our `.csv` file contains nearly a decades worth of data which makes for a large file.
Our study period is 
2009-2011. We can subset the data so that we have just these three years.

We need to include the time zone to get this to work correctly. If we provide the time zone,
R will take care of daylight savings and leap year for us.


#break up how the query works. 

    #subset out some of the data - 2009-2011
    harMet15.09.11 <- subset(harMet_15Min, datetime >= as.POSIXct('2009-01-01 00:00',
            tz = "America/New_York") & datetime <=
            as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))
    
    #check to make sure it worked.
    head(harMet15.09.11[1])

    ##                   datetime
    ## 140255 2009-01-01 00:00:00
    ## 140256 2009-01-01 00:15:00
    ## 140257 2009-01-01 00:30:00
    ## 140258 2009-01-01 00:45:00
    ## 140259 2009-01-01 01:00:00
    ## 140260 2009-01-01 01:15:00

    tail(harMet15.09.11[1])

    ##                   datetime
    ## 245369 2011-12-31 22:30:00
    ## 245370 2011-12-31 22:45:00
    ## 245371 2011-12-31 23:00:00
    ## 245372 2011-12-31 23:15:00
    ## 245373 2011-12-31 23:30:00
    ## 245374 2011-12-31 23:45:00

It worked, the first (min) day is 1 Jan 2009 and the last day (max) is 31 Dec
2011.

>#challenge - subset out a month
>#challenge 2 - subset out 2009 and plot it
>#note: we should plot in L01 and in each lesson so they get good at it.


## NoData Values - Dealing with data gaps
Recall from our metadata that missing values are given an NA value. One must always 
check for missing values in any of the variables with which one is working.  Do we 
have missing values in our data set? An easy way to check for this is the
is.na() function. By asking for the sum() of is.na() we can see how many 
NA/missing values we have. 


    #Check for NA values
    sum(is.na(harMet_15Min$datetime))

    ## [1] 44

    sum(is.na(harMet15$airt))

    ## [1] 42

    sum(is.na(harMet15$prec))

    ## [1] 5915

    sum(is.na(harMet15$parr))

    ## [1] 50
As you can see here we have no NA values within the Date/Time data but we do
have NA values in our other variables.  

When you encounter NA or missing values (blank, NaN, etc.) in your data you need
to decide at this point how to deal with them.  By default R treats NA values as
blanks not as zeros.  This is good as a value of zero (no rain today) is not the
same as lack of data (we didn't measure the rain today). 

The way one deals with missing values and data gaps will depend on what type of 
data is used, the analysis conducted, and the significance of the gap or 
missing value.  The many issues associated with this can be complex and beyond 
the scope of this lesson.  As recommendations vary on how to deal with the data 
you should look up what others recommend for the specific data type you are 
using and analyses you plan.  Other resources included:

 1)[LINK http://www.statmethods.net/input/missingdata.html] Quick-R: Missing 
 Data -- R code for dealing with data but not why one should use a specific technique 
 2) [LINK] XXX article/ site for general recommendations.  Any classics in ecology? 

How should we deal with it in our case?  As the goal of the our current analysis
is to get a good feeling about the general patterns of greening up and browning 
down we can leave the NAs at this point.  Compared to the full dataset (376,800 
data points) the few missing values are not going to interfere with our analysis.
However, it is important to remember that there are null values in case you 
decide to revisit this data set for a more detailed time-series analysis where 
the data gap would be a problem.  


#should include something about na.rm when performing calculations...
#why do they care about no data values?




 #we worked with the file below in L00 -- how about monthly data instead?

# Challenge 1: Uploading and Preparing Data
Load the daily .csv datafile from Harvard Forest

Currently we have been using the 15 minute data from the Harvard Forest. 
However, overall we are interested in larger scale patterns of greening-up and
browning-down.  Daily atmospheric data are therefore far more appropriate for our
work than the 15 minute data.  

Let's import the Daily Meteorological data from the Harvard Forest using the
skills we have recently learned. 


    #import daily file
    harMet.daily <- read.csv("AtmosData/HARV/hf001-06-daily-m.csv", 
          stringsAsFactors = FALSE)
    #check it out
    str(harMet.daily)

    ## 'data.frame':	5345 obs. of  46 variables:
    ##  $ date     : chr  "2001-02-11" "2001-02-12" "2001-02-13" "2001-02-14" ...
    ##  $ jd       : int  42 43 44 45 46 47 48 49 50 51 ...
    ##  $ airt     : num  -10.7 -9.8 -2 -0.5 -0.4 -3 -4.5 -9.9 -4.5 3.2 ...
    ##  $ f.airt   : chr  "" "" "" "" ...
    ##  $ airtmax  : num  -6.9 -2.4 5.7 1.9 2.4 1.3 -0.7 -3.3 0.7 8.9 ...
    ##  $ f.airtmax: chr  "" "" "" "" ...
    ##  $ airtmin  : num  -15.1 -17.4 -7.3 -5.7 -5.7 -9 -12.7 -17.1 -11.7 -1.3 ...
    ##  $ f.airtmin: chr  "" "" "" "" ...
    ##  $ rh       : int  40 45 70 78 69 82 66 51 57 62 ...
    ##  $ f.rh     : chr  "" "" "" "" ...
    ##  $ rhmax    : int  58 85 100 100 100 100 100 71 81 78 ...
    ##  $ f.rhmax  : chr  "" "" "" "" ...
    ##  $ rhmin    : int  22 14 34 59 37 46 30 34 37 42 ...
    ##  $ f.rhmin  : chr  "" "" "" "" ...
    ##  $ dewp     : num  -22.2 -20.7 -7.6 -4.1 -6 -5.9 -10.8 -18.5 -12 -3.5 ...
    ##  $ f.dewp   : chr  "" "" "" "" ...
    ##  $ dewpmax  : num  -16.8 -9.2 -4.6 1.9 2 -0.4 -0.7 -14.4 -4 0.6 ...
    ##  $ f.dewpmax: chr  "" "" "" "" ...
    ##  $ dewpmin  : num  -25.7 -27.9 -10.2 -10.2 -12.1 -10.6 -25.4 -25 -16.5 -5.7 ...
    ##  $ f.dewpmin: chr  "" "" "" "" ...
    ##  $ prec     : num  0 0 0 6.9 0 2.3 0 0 0 0 ...
    ##  $ f.prec   : chr  "" "" "" "" ...
    ##  $ slrt     : num  14.9 14.8 14.8 2.6 10.5 6.4 10.3 15.5 15 7.7 ...
    ##  $ f.slrt   : chr  "" "" "" "" ...
    ##  $ part     : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ f.part   : chr  "M" "M" "M" "M" ...
    ##  $ netr     : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ f.netr   : chr  "M" "M" "M" "M" ...
    ##  $ bar      : int  1025 1033 1024 1016 1010 1016 1008 1022 1022 1017 ...
    ##  $ f.bar    : chr  "" "" "" "" ...
    ##  $ wspd     : num  3.3 1.7 1.7 2.5 1.6 1.1 3.3 2 2.5 2 ...
    ##  $ f.wspd   : chr  "" "" "" "" ...
    ##  $ wres     : num  2.9 0.9 0.9 1.9 1.2 0.5 3 1.9 2.1 1.8 ...
    ##  $ f.wres   : chr  "" "" "" "" ...
    ##  $ wdir     : int  287 245 278 197 300 182 281 272 217 218 ...
    ##  $ f.wdir   : chr  "" "" "" "" ...
    ##  $ wdev     : int  27 55 53 38 40 56 24 24 31 27 ...
    ##  $ f.wdev   : chr  "" "" "" "" ...
    ##  $ gspd     : num  15.4 7.2 9.6 11.2 12.7 5.8 16.9 10.3 11.1 10.9 ...
    ##  $ f.gspd   : chr  "" "" "" "" ...
    ##  $ s10t     : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ f.s10t   : chr  "M" "M" "M" "M" ...
    ##  $ s10tmax  : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ f.s10tmax: chr  "M" "M" "M" "M" ...
    ##  $ s10tmin  : num  NA NA NA NA NA NA NA NA NA NA ...
    ##  $ f.s10tmin: chr  "M" "M" "M" "M" ...

    #Metadata
    #Differences in 2 variable names PAR=part, DateTime=date
    #Has Julian days already calculated name =jd
    
    #Check for NA values
    sum(is.na(harMet.daily$date))

    ## [1] 0

    sum(is.na(harMet.daily$airt))

    ## [1] 0

    sum(is.na(harMet.daily$prec))

    ## [1] 0

    sum(is.na(harMet.daily$part))

    ## [1] 1032

    #OuputNote: PART is missing 1032 values
    
    #convert date 
    harMet.daily$date <- as.POSIXct(harMet.daily$date,format = "%Y-%m-%d",
          tz = "America/New_York")
    #check it out
    str(harMet.daily [1])

    ## 'data.frame':	5345 obs. of  1 variable:
    ##  $ date: POSIXct, format: "2001-02-11" "2001-02-12" ...

    #julian data - already in file. Field jd
    
    #subset out some of the data - 2009-2011
    harMetDaily.09.11 <- subset(harMet.daily, date >= as.POSIXct('2009-01-01',
            tz = "America/New_York") & date <=
            as.POSIXct('2011-12-31', tz = "America/New_York"))
    
    #check it
    head(harMetDaily.09.11$date)

    ## [1] "2009-01-01 EST" "2009-01-02 EST" "2009-01-03 EST" "2009-01-04 EST"
    ## [5] "2009-01-05 EST" "2009-01-06 EST"

    tail(harMetDaily.09.11$date)

    ## [1] "2011-12-26 EST" "2011-12-27 EST" "2011-12-28 EST" "2011-12-29 EST"
    ## [5] "2011-12-30 EST" "2011-12-31 EST"

    #do we still have the NA in part?
    sum(is.na(harMetDaily.09.11$part))

    ## [1] 1

    #Output note: now only 1 NA!

