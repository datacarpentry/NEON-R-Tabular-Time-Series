---
layout: post
title: "Lesson 02b: Refining Time Series Data: Subsetting Data by Date and NoData Values in R"
date: 2015-10-23
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser]
dateCreated: 2015-10-22
lastModified: 2015-11-18
tags: module-1
packagesLibraries: [lubridate, ggplot2]
category: 
description: "This lesson will teach individuals how to prepare tabular data for
further analysis in R, addressing missing values and how to subset the data into
a new data frame."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Introduction-to-Tabular-Time-Series-In-R
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
Please be sure you have the most current version of `R` and, preferably,
RStudio to write your code.

####R Libraries to Install
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>
<li><strong>ggplot2:</strong> <code> install.packages("ggplot2")</code></li>

  <a href="http://neondataskills.org/R/Packages-In-R/" target="_blank">
More on Packages in R - Adapted from Software Carpentry.</a>

####Data to Download

<a href="http://files.figshare.com/2437700/AtmosData.zip" class="btn btn-success">
Download Atmospheric Data</a>

The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the <a href="XXX" target="_blank">Setting A Working Directory In R</a> lesson prior to beginning the lesson.

####Recommended Pre-Lesson Reading


</div>

In [{{site.baseurl}} / LINKHERE](Lesson 02 - ) we imported a
`.csv` time series dataset and learned out to convert data fields into date-time
classes.  We'll use that micrometereology data (from file 
`hf001-10-15min-m.csv`) to explore the relationship between our variables of 
interest, air temperature, precipitation, and photosynetheically active 
radiation (PAR) in regards to plant phenology.  

If not already done we need to load the file and convert the datetime field to a
POSIXct class date-time data type field. 


    # Load packages required for entire script
    library(lubridate)  #work with dates
    library(ggplot2)  # plotting
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")
    
    #Load csv file of 15 min meterological data from Harvard Forest
    #Factors=FALSE so strings, series of letters/ words/ numerals, remain characters
    harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                         stringsAsFactors = FALSE)
    #convert date time
    harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                    format = "%Y-%m-%dT%H:%M",
                                    tz = "America/New_York")

##Subsetting
Our `.csv` file contains nearly a decades worth of data which makes for a large
file. The time from of our study is only 2009-2011. We can subset the data so 
that we have just these three years.

To to this we will use the `subset()` function, with the syntax
`NewObject <- subset ( ObjectToBeSubset, CriteriaForSubsetting ) `.  
We want all data between the beginning of 1 January 2009 and the end of 31 
December 2011 so we set our criteria to be "any datetime that is greater than or
equal to 1 Jan 09 at 0:00 AND datetime less than or equal to 31 Dec 11 at
23:59".

We need to include the time zone to get this to work correctly. If we provide
the time zone, R will take care of daylight savings and leap year for us.


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

It worked! The first day is 1 Jan 2009 and the last day is 31 Dec 2011.

Sometime we might want to share just a subset of our data with a colleague.  We 
can do that by writing our subsetted R object to a .csv file.  Remember, that
when naming any file to give it a concise yet description name.  By default, the
the .csv will be written to your working directory. 


    #writing the subset of harMet15 data to .csv
    write.csv(harMet15.09.11, file="Met_HARV_15min_2009_2011.csv")



#Challenge: Subset and Plot Precipitation for July 2010 in the Harvard Forest


    ##                   datetime  jd airt f.airt rh f.rh dewp f.dewp prec f.prec
    ## 192671 2010-07-01 00:00:00 181 10.7        73       6.2           0       
    ## 192672 2010-07-01 00:15:00 182 10.2        76       6.3           0       
    ## 192673 2010-07-01 00:30:00 182  9.8        79       6.4           0       
    ## 192674 2010-07-01 00:45:00 182 10.3        77       6.4           0       
    ## 192675 2010-07-01 01:00:00 182 11.0        72       6.2           0       
    ## 192676 2010-07-01 01:15:00 182 10.7        74       6.3           0       
    ##        slrr f.slrr parr f.parr netr f.netr  bar f.bar wspd f.wspd wres
    ## 192671    0           0         -51        1018        0.6         0.5
    ## 192672    0           0         -51        1018        0.5         0.5
    ## 192673    0           0         -48        1018        0.4         0.3
    ## 192674    0           0         -50        1018        0.6         0.3
    ## 192675    0           0         -55        1018        0.7         0.4
    ## 192676    0           0         -51        1018        0.2         0.1
    ##        f.wres wdir f.wdir wdev f.wdev gspd f.gspd s10t f.s10t
    ## 192671          55          27         1.1        20.7       
    ## 192672          61          20         1.1        20.6       
    ## 192673          10          37         1.0        20.6       
    ## 192674         269          52         3.0        20.5       
    ## 192675         244          50         2.3        20.4       
    ## 192676         106          24         0.8        20.4

![ ]({{ site.baseurl }}/images/rfigs/TS03-Subset-Data-and-No-Data-Values/challenge-code-subsetting-1.png) 


## Missing Data - Dealing with data gaps

###Checking for No Data Values
In the <a href="XXX" target="_blank"> Understand The Data</a>
lesson we viewed the metadata associated with this data and found out that the  
missing values are given an NA value. One must always check for missing values 
in any of the variables with which one is working.  

Do we have missing values in our data set? An easy way to check for this is the
is.na() function. By asking for the sum() of is.na() we can see how many 
NA/missing values we have. 


    #Check for NA values
    sum(is.na(harMet15.09.11$datetime))

    ## [1] 0

    sum(is.na(harMet15.09.11$airt))

    ## [1] 2

    sum(is.na(harMet15.09.11$prec))

    ## [1] 863

    sum(is.na(harMet15.09.11$parr))

    ## [1] 4
As we can see here we have no NA values within the `datetime` field but we do
have NA values in our other variables.  

###Deal with No Data Values
When we encounter NA or missing values (blank, NaN, -9999, etc.) in our data we
need to decide at how to deal with them.  By default R treats NA values as 
blanks, not as zeros.  This is good as a value of zero (no rain today) is not
the same as lack of data (we didn't measure the rain today). 

The way one deals with missing values and data gaps will depend on what type of 
data is used, the analysis conducted, and the significance of the gap or 
missing value.  The many issues associated with this can be complex and beyond 
the scope of this lesson.  As recommendations vary on how to deal with the data 
you should look up what others recommend for the specific data type you are 
using and analyses you plan.  Other resources included:

 1)<a href="http://www.statmethods.net/input/missingdata.html" target="_blank"> Quick-R: Missing  Data</a> 
 -- R code for dealing with missing data 
 2) The Institute for Digital Research and Education has an <a href="http://www.ats.ucla.edu/stat/r/faq/missing.htm" target="_blank"> R FAQ on Missing Values</a>.

How should we deal with it in our case?  As the goal of the our current analysis
is to get a good feeling about the general patterns of greening up and browning 
down we can leave the NAs in the differnet variables at this point. With no 
missing values in the `datetime` field the x-axis on our plots will not be 
missing values.  Compared to the full dataset (376,800 data points) the few 
missing values are not going to interfere with our analysis.

However, it is important to remember that there are null values in case we 
decide to revisit this data set for a more detailed time-series analysis where 
the data gap would be a problem.  

###NA Values in Functions & Calculations
One time it is very important to consider NA values if we are doing calculations
or using a fuction on fields that may contain NA values.  Missing values can
cause error in calculations.  By default `R` will not calculate certain function
if they have a NA value in it.  

    #calculate mean of air temperature
    mean(harMet15.09.11$airt)

    ## [1] NA

`R` will not return a value for the mean as there NA values in the air temperature.  However, we know that there are only 2 of 105,108 observations of air temperature missing, so we aren't that worried about those two missing values skewing the three year air temperature mean.  We can tell `R` to not include the missing values by using `na.rm=` within the function.  


    #calculate mean of air temperature
    mean(harMet15.09.11$airt, na.rm=TRUE)

    ## [1] 8.467904

We now see that the average air temperature across the three years was 8.5°C.  

# Challenge 1: Uploading and Preparing Data
Load the daily .csv datafile from Harvard Forest

We have been using the 15 minute data from the Harvard Forest. However, overall
we are interested in larger scale patterns of greening-up and browning-down.  
Daily atmospheric data are therefore far more appropriate for our work than the 
15 minute data.  

1) Import the Daily Meteorological data from the Harvard Forest.
2) Check the metadata to see what the field names are for the variable of
interest (precipitation, air temperature, PAR, day and time ).
3) If needed, convert the data type of data fields.
4) Check for missing data and decide what to do with any that exist.
5) Subset out the data for the duration of our study: 2009-2011.  Be sure to recheck the quality of the data at this point. 
6) Write the subset to a .csv file. 
7) Create a fully labelled plot for the air temperature during our study. 


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

    ## 'data.frame':	5345 obs. of  1 variable:
    ##  $ date: Date, format: "2001-02-11" "2001-02-12" ...

    ## [1] 0

    ## [1] 0

    ## [1] 0

    ## [1] 1032

    ## [1] "2009-01-01" "2009-01-02" "2009-01-03" "2009-01-04" "2009-01-05"
    ## [6] "2009-01-06"

    ## [1] "2011-12-26" "2011-12-27" "2011-12-28" "2011-12-29" "2011-12-30"
    ## [6] "2011-12-31"

    ## [1] 1

![ ]({{ site.baseurl }}/images/rfigs/TS03-Subset-Data-and-No-Data-Values/Challenge-code-harMet.daily-1.png) 

