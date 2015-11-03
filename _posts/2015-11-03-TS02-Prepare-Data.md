---
layout: post
title: "Lesson 02: Preparing the Data to Work With"
date: 2015-10-23
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
dateCreated: 2015-10-22
lastModified: 2015-10-29
tags: module-1
description: "This lesson will teach individuals how to prepare tabular data for furtheranalysis in R, addressing missing values and date-time formats. Students will alsolearn how to convert characters to a time class, to convert date-time to Julian day, and how to subset the data into a new data frame."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
comments: false
---

<section id="table-of-contents" class="toc">
  <header>
    <h3>Contents</h3>
  </header>
<div id="drawer" markdown="1">
*  Auto generated table of contents
{:toc}
</div>
</section><!-- /#table-of-contents -->

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
 * Use metadata to get more information about input data


###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and preferably
R studio to write your code.

####R Libraries to Install
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>

####Data to Download

Make sure you have downloaded the AtmosData folder from
http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068

####Recommended Pre-Lesson Reading
Lessons 00-01 in this Time Series learning module

</div>

#Lesson Two: Prepare your data so you can work with it

We will use basic R and the lubridate package for working with date-time formats.
However, there are a few options for working with date-time formats
(readr, zoo), which are based on similar concepts, you will be able to use help
text to explore those on your own as you choose. 


    # Load packages required for entire script
    library(lubridate)  #working with dates

## Dealing with data gaps
Recall from our metadata that missing values are given an NA. One must always 
check for missing values in any of the variables one is working with.  Do we 
have missing values in our data set? An easy way to check for this is the
is.na() function. By asking for the sum() of is.na() we can see how many 
NA/missing values we have. 

    #Check for NA values
    sum(is.na(harMet15$datetime))

    ## [1] 0

    sum(is.na(harMet15$airt))

    ## [1] 42

    sum(is.na(harMet15$prec))

    ## [1] 5915

    sum(is.na(harMet15$parr))

    ## [1] 50
As you can see here we have no NA values for within the Date/Time data but we do
have NA values in our other variables.  

When you encounter NA or missing values (blank, NAN, etc) in your data you  need
to decide at this point how to deal with them.  By default R treats NA values as
blanks not as zeros.  This is good as a value of zero (no rain today) is not the
same as lack of data (we didn't measure the rain today). 

The way one deals with missing values and data gaps will depend on what type of 
data is being dealt with, the analysis done, and the significance of the gap or 
missing value.  The many issues associated with this can be complex and beyond 
the scope of this lesson.  As recommendations vary on how to deal with the data 
you should look up what others recommend for the specific data type you are 
dealing with.  Other resources included:

 1)[LINK http://www.statmethods.net/input/missingdata.html] Quick-R: Missing 
 Data -- R code for dealing with data but not why one should use a specific technique 
 2) [LINK] XXX article/ site for general recommendations.  Any classics in ecology? 

How should we deal with it in our case?  As the goal of the our current analysis
is to get a good feeling about the general patterns of greening up and browning 
down we can leave the NAs at this point.  Compared to the full dataset (376,800 
data points) the few missing values are not going to interfere with our analysis.
However, it is important to remember that there are null values incase you 
decide to revisit this data set for a more detailed time-series analysis where 
the data gap would be a problem.  


##Dealing with date and time
Look back up at the results from str(harMet15) that the data 'datetime' is seen as a 
character type. But to work with this column as a date-time, which is important 
for the analyses and plotting you will learn, we need to convert it to a time 
class.

First we will reformat the character format of the 'datetime' column.  The first
step of this is to remove any acutal characters from the field. Currently the date
and time are seperated by a 'T'.  Let's remove that.  


    #convert from character to time type
    #datetime input looks like this: 2005-01-01T00:15
    
    #remove the "T" and replace it with a space
    #gsub() replaces all occurances; sub() just replaces first occurance in the set
    harMet15$datetime <- gsub("T", " ", harMet15$datetime)
    #make sure it worked.  Adding [1] allows us to just look at structure for first
    #variable in dataframe instead of all of them, giving a cleaner output.  If we #wanted the 4th column/variable we would type [4].
    head(harMet15[1])

    ##           datetime
    ## 1 2005-01-01 00:15
    ## 2 2005-01-01 00:30
    ## 3 2005-01-01 00:45
    ## 4 2005-01-01 01:00
    ## 5 2005-01-01 01:15
    ## 6 2005-01-01 01:30

Now we need to convert from a character to a time class.  R recognizes several 
different date and time classes with formats for date, time, or date and time field
differently. Some are within the core R and others are available through packages.

### Exploring Time and Data classes
Let's explore a few date and time formats before continuing on our with our 
analysis. A common format for data that consists of only dates is Date.


    #Convert char data to date (no time) 
    date <- as.Date("2015-10-19 10:15")   
    str(date)

    ##  Date[1:1], format: "2015-10-19"

    head(date)

    ## [1] "2015-10-19"

Here we can see that the date is now not a character but is now date `str(date)` 
and that we only have the calender date with all time information stripped away 
`head(Date)`.  If we only had date information to start with it is a good idea 
to store data in the least complex format that is acceptable so `Date` would 
work for us, however, we also time data.

Given that we do have time data and that it is important for our time series we
need to use a format that includes time and date.  There are formats for dealing
with time and date class data that are part of the core R (POSIX) and different
or modified formats in many packages (`lubridate`, `chron`, `ts`, `zoo`, `timeSeries`).
We will further discuss POSIX and use `lubridate` in this module.  If you will be
using time series data you can find more information about the other
packages in their documentation. 
Bonus: If you have to use time without dates attached look into the chron package.

Within the core R there are two closely related classes for date and time:
POSIXct and POSIXlt.  Let's explore both of these before choosing which one
to use with our data.


    #Convert char data to date and time.
    TimeDate <- as.POSIXct("2015-10-19 10:15")   
    str(TimeDate)

    ##  POSIXct[1:1], format: "2015-10-19 10:15:00"

    head(TimeDate)

    ## [1] "2015-10-19 10:15:00 MDT"

Here we can see that the date is now not a character but is now POSIXct. When
looking at the data we see the date and time with time zone designation. 

POSIXct stores date and time as the number of seconds since 1 January 1970
(negative numbers are used for dates before 1970). As each date and time is 
just a single number this format is easy to use in dataframes and to convert
from one format to another. 


    unclass(TimeDate)

    ## [1] 1445271300
    ## attr(,"tzone")
    ## [1] ""

Here we see the number of seconds from 1 January 1970 and 9 October 2015 and
see that it has a time zone attribute stored with it. 

While easy for data storage and  manipulations, humans aren't so good at working
with seconds from 1970 to figure out a date. Plus, we often want to pull out some
portion of the data (e.g. months).  POSIXlt stores date time information in a
more human friendly format we are used to seeing (e.g. second, min, hour, day
of month, month, year, numeric day of year, etc). 

    #Convert char data to POSIXlt date and time
    TimeDatelt<- as.POSIXlt("2015-10-19 10:15")  
    str(TimeDatelt)

    ##  POSIXlt[1:1], format: "2015-10-19 10:15:00"

    head(TimeDatelt)

    ## [1] "2015-10-19 10:15:00 MDT"

    unclass(TimeDatelt)

    ## $sec
    ## [1] 0
    ## 
    ## $min
    ## [1] 15
    ## 
    ## $hour
    ## [1] 10
    ## 
    ## $mday
    ## [1] 19
    ## 
    ## $mon
    ## [1] 9
    ## 
    ## $year
    ## [1] 115
    ## 
    ## $wday
    ## [1] 1
    ## 
    ## $yday
    ## [1] 291
    ## 
    ## $isdst
    ## [1] 1
    ## 
    ## $zone
    ## [1] "MDT"
    ## 
    ## $gmtoff
    ## [1] NA

Here we can see that the date is now not a character but is now POSIXlt. When
looking at the data we see the date and time with time zone designation
(same as POSIXct). But when we look at the components using `unclass()` we can
see the seperate sections of the date and time.  Two components may appear wrong
1) $mon = , but October is the 10th month and 
2) $year = 115, not 2015.  
We need to look at the POSIXlt documentation to figure out why this is happening. 


    #help for POSIXlt
    ?POSIXlt

Looking at the Details we see that POSIXlt $mon is classified from 0-11 so
October would be the 9th month and $year is the number of years since 1900 so
2015 is year 115.  The unclassed date components are not incorrect, just not
what we expected. 

Having dates calssified as seperate components makes this time class a bit more
difficult to use in dataframes and to manipulate, which is why we won't use
POSIXlt for this lesson.  Instead we can specified which format (year-month-day
hour:minute) we wanted to see the date and time when using POSIXct.  This way we 
know what the date is and the program can still work with
the date/time in a single format.  

###Resuming Dealing with Date and Time 
Now that we have figured out the POSIXct is the best date/time class for us to 
use with this data, let's return to converting the date and time data for the
Harvard Forest. 

We now need to specific the time zone. Remember we learned in the
metadata that these data were recorded in Eastern Standard Time. For R we need
to look up the name for the timezone in the 'tz' database. You can find the list 
here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
In this database, Eastern Standard Time is called "America/New_York".


    #convert to date-time class
    harMet15$datetime <- as.POSIXct(harMet15$datetime,format = "%Y-%m-%d %H:%M",
        tz = "America/New_York")
    
    #make sure it worked. 
    str(harMet15[1])

    ## 'data.frame':	376800 obs. of  1 variable:
    ##  $ datetime: POSIXct, format: "2005-01-01 00:15:00" "2005-01-01 00:30:00" ...

##Convert to Julian days
In some cases you might want to use Julian days, which gives each day of the 
year a number starting with 1 on Jan 1 and counting up to 365 or 366 on 
December 31 depending on if it is a leap year or not. 

Note: This format can also be called ordinal day or year day, and, ocassionally,
Julian day can refer to a numeric count since 1 January 4713 BC.

Reasons you might want to convert to Julian days are for smoother plotting and manipulation of data.


    # convert to julian days
    # here we will use yday, which is a function from the lubridate package;
    # to learn more about it type
    ?yday
    
    harMet15$julian <- yday(harMet15$datetime)  
    #make sure it worked all the way through.  Dataframe was 30 variables so julian should be 31st.
    head(harMet15[31]) 

    ##   julian
    ## 1      1
    ## 2      1
    ## 3      1
    ## 4      1
    ## 5      1
    ## 6      1

    tail(harMet15[31])

    ##        julian
    ## 376795    273
    ## 376796    273
    ## 376797    273
    ## 376798    273
    ## 376799    273
    ## 376800    274

##Subsetting
The file contains nearly a decades worth of data.  However, we are more 
interested in recent patterns, let's just take three years 2009-2011. To do this we
need to subset the data so that we have just the three years we are interested in.
We need to include the time zone to get this to work correctly.


    #subset out some of the data - 2009-2011
    harMet15.09.11 <- subset(harMet15, datetime >= as.POSIXct('2009-01-01 00:00',
            tz = "America/New_York") & datetime <=
            as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))
    
    #check to make sure it worked.
    summary(harMet15.09.11[1])

    ##     datetime                  
    ##  Min.   :2009-01-01 00:00:00  
    ##  1st Qu.:2009-10-01 18:11:15  
    ##  Median :2010-07-02 12:22:30  
    ##  Mean   :2010-07-02 12:31:54  
    ##  3rd Qu.:2011-04-02 06:33:45  
    ##  Max.   :2011-12-31 23:45:00

It worked, the first (min) day is 1 Jan 2009 and the last day (max) is 31 Dec
2011. 

# Challenge 1: Uploading and Preparing Data
Load daily .csv datafile from Harvard Forest

Currently we have been using the 15 minute data from the Harvard Forest. 
However, overall we are interested in larger scale patterns of greening-up and
browning-down.  Daily atmospheric data is therefore far more appropriate for our
work than the 15 minute data is.  

Let's import the Daily Meteorological data from the Harvard Forest using the
skills we have recently learned. 


    #import daily file
    harMet.daily <- read.csv("data/AtmosData/HARV/hf001-06-daily-m.csv", 
          stringsAsFactors = FALSE)

    ## Warning in file(file, "rt"): cannot open file 'data/AtmosData/HARV/
    ## hf001-06-daily-m.csv': No such file or directory

    ## Error in file(file, "rt"): cannot open the connection

    #check it out
    str(harMet.daily)

    ## 'data.frame':	5345 obs. of  47 variables:
    ##  $ date     : POSIXct, format: "2001-02-11" "2001-02-12" ...
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
    ##  $ winter   : logi  FALSE FALSE TRUE FALSE FALSE TRUE ...

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
    harMetDaily.09.11 <- subset(harMet.daily, date >= as.POSIXct('2009-01-01 00:00',
            tz = "America/New_York") & date <=
            as.POSIXct('2011-12-31 23:59', tz = "America/New_York"))
    
    #check it
    summary(harMetDaily.09.11$date)

    ##                  Min.               1st Qu.                Median 
    ## "2009-01-01 00:00:00" "2009-10-01 12:00:00" "2010-07-02 00:00:00" 
    ##                  Mean               3rd Qu.                  Max. 
    ## "2010-07-02 00:20:52" "2011-04-01 12:00:00" "2011-12-31 00:00:00"

    #do we still have the NA in part?
    sum(is.na(harMetDaily.09.11$part))

    ## [1] 1

    #Output note: now only 1 NA!
