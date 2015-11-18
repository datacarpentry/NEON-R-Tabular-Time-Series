---
layout: post
title: "Lesson 02: Convert Date/Time Fields from Characters to a Date/time Class (POSIX) in R"
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

**R Skill Level:** Intermediate - you've got the basics of `R` down and 
understand the general structure of tabular data.

<div id="objectives" markdown="1">

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

The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").

####Recommended Pre-Lesson Reading

</div>


In this lesson, we will use functions from both base `R` and the `lubridate` 
library to work with with date-time formats.

#BELOW is background  - not sure this belongs here.
NOTE: there are a few options for working with date-time formats
(readr, zoo), which are based on similar concepts, you will be able to use help
text to explore those on your own as you choose. 


    # Load packages required for entire script
    library(lubridate)  #work with dates
    library(ggplot2)  #efficient plotting

In [{{site.baseurl}} / LINKHERE](Lesson 00 - NEED TO ADD LINK) we imported a
`.csv` time series dataset. We learned how to cleanly plot these data by 
converting the date field to an `R` `Date` field
format. In this lesson we will explore how to work with data that contain both a 
date AND a time stamp.

We will use the `hf001-10-15min-m.csv` file that file contains micrometereology
data including our variables of interest: temperature, precipitation and PAR, 
for Harvard Forest, aggregated at 15 minute intervals.

We will begin by loading the data and viewing its structure in `R`.


    #Load csv file of 15 min meterological data from Harvard Forest
    #don't load strings (a series of letters or numerals) as factors so they remain characters
    harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                         stringsAsFactors = FALSE)
    
    #what type of R object is our imported data?
    class(harMet_15Min)

    ## [1] "data.frame"

    #what type of R object is our imported data?
    str(harMet_15Min)

    ## 'data.frame':	376800 obs. of  30 variables:
    ##  $ datetime: chr  "2005-01-01T00:15" "2005-01-01T00:30" "2005-01-01T00:45" "2005-01-01T01:00" ...
    ##  $ jd      : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ airt    : num  5.1 5 4.9 4.7 4.5 4.6 4.6 4.7 4.6 4.6 ...
    ##  $ f.airt  : chr  "" "" "" "" ...
    ##  $ rh      : int  84 84 85 86 87 87 87 88 88 88 ...
    ##  $ f.rh    : chr  "" "" "" "" ...
    ##  $ dewp    : num  2.5 2.5 2.6 2.6 2.6 2.7 2.7 2.8 2.8 2.8 ...
    ##  $ f.dewp  : chr  "" "" "" "" ...
    ##  $ prec    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.prec  : chr  "" "" "" "" ...
    ##  $ slrr    : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.slrr  : chr  "" "" "" "" ...
    ##  $ parr    : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.parr  : chr  "" "" "" "" ...
    ##  $ netr    : int  -58 -59 -59 -58 -58 -58 -57 -57 -59 -62 ...
    ##  $ f.netr  : chr  "" "" "" "" ...
    ##  $ bar     : int  1017 1017 1017 1017 1017 1017 1017 1017 1017 1016 ...
    ##  $ f.bar   : chr  "" "" "" "" ...
    ##  $ wspd    : num  2.6 2.3 2.1 1.8 1.4 1.6 1.5 1.5 1.6 1.7 ...
    ##  $ f.wspd  : chr  "" "" "" "" ...
    ##  $ wres    : num  2.4 2.1 1.8 1.6 1.2 1.4 1.3 1.4 1.4 1.6 ...
    ##  $ f.wres  : chr  "" "" "" "" ...
    ##  $ wdir    : int  205 213 217 226 224 214 214 213 217 214 ...
    ##  $ f.wdir  : chr  "" "" "" "" ...
    ##  $ wdev    : int  26 25 27 26 29 30 30 27 27 25 ...
    ##  $ f.wdev  : chr  "" "" "" "" ...
    ##  $ gspd    : num  7.2 5.9 5.8 5.1 4.6 4.4 5 4.2 4.2 4.6 ...
    ##  $ f.gspd  : chr  "" "" "" "" ...
    ##  $ s10t    : num  0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 ...
    ##  $ f.s10t  : chr  "" "" "" "" ...

##Dealing with date and time

Have a look at the datetime field in the `harmet_15Min object`. What format is it 
in? 


    #view field format
    class(harMet_15Min$datetime)

    ## [1] "character"

    #view sample data
    head(harMet_15Min$datetime)

    ## [1] "2005-01-01T00:15" "2005-01-01T00:30" "2005-01-01T00:45"
    ## [4] "2005-01-01T01:00" "2005-01-01T01:15" "2005-01-01T01:30"


Similar to lesson one, our data are in a character format. We need to convert
it to date time. What happens when we use the `as.Date` method on our datetime
field?


    #convert field to date format
    har_dateOnly <- as.Date(harMet_15Min$datetime)
    
    #view data
    head(har_dateOnly)

### Exploring Date and Time classes

The `as.Date` method worked great for a field with just dates, but it doesn't 
capture time. That's take a minute to explore the various date/time formats in `R`.

###R - Date Class - as.Date
We can use the as.Date method to convert a date field in string / character format
to an `R Date` class. It will ignore all values after the date string.


    #Convert character data to date (no time) 
    myDate <- as.Date("2015-10-19 10:15")   
    str(myDate)

    ##  Date[1:1], format: "2015-10-19"

    head(myDate)

    ## [1] "2015-10-19"

    #whhat happens if the date has text at the end?
    myDate2 <- as.Date("2015-10-19Hello")   
    str(myDate2)

    ##  Date[1:1], format: "2015-10-19"

    head(myDate2)

    ## [1] "2015-10-19"

###Date and Time - the POSIX class

Given that we do have time data and that it is important for our time series we
need to use a format that includes time and date.  

NOTE: If you have to use time without dates attached look into the chron package.
{ : .notice }

Base `R` offers two closely related classes for date and time:
`POSIXct` and `POSIXlt`. Let's explore both of these before choosing which one
to use with our data.


    #Convert character data to date and time.
    timeDate <- as.POSIXct("2015-10-19 10:15")   
    str(timeDate)

    ##  POSIXct[1:1], format: "2015-10-19 10:15:00"

    head(timeDate)

    ## [1] "2015-10-19 10:15:00 MDT"

The `as.POSIXct` method converts a date / time string into a `POSIXct` or date/time
class.

If we look at the data, we see the date and time with a time zone designation. 


    #view date - notice the time zone - MDT (mountain daily time)
    timeDate

    ## [1] "2015-10-19 10:15:00 MDT"

#THIS SECTION NEEDS TO BE SIMPLIFIED SIGNIFICANTLY. too verbose
#just state - there are two date time options
POSIXct vs POSIXlt. the big different is how the data are stored.

#Explain why one might be preferred over the other. As written this is distracting 
from the lesson - given it's a beginner lesson.

POSIXct stores date and time as the number of seconds since 1 January 1970
(negative numbers are used for dates before 1970). As each date and time is 
just a single number this format is easy to use in dataframes and to convert
from one format to another. 


    unclass(timeDate)

    ## [1] 1445271300
    ## attr(,"tzone")
    ## [1] ""

Here we see the number of seconds from 1 January 1970 to 9 October 2015 and
see that it has a time zone attribute stored with it. 

While easy for data storage and  manipulations, humans aren't so good at working
with seconds from 1970 to figure out a date. Plus, we often want to pull out some
portion of the data (e.g., months).  POSIXlt stores date and time information in a
more human-friendly format that we are used to seeing (e.g., second, min, hour, day
of month, month, year, numeric day of year, etc). 


    #Convert character data to POSIXlt date and time
    timeDatelt<- as.POSIXlt("2015-10-1910:15")  
    str(timeDatelt)

    ##  POSIXlt[1:1], format: "2015-10-19 10:15:00"

    head(timeDatelt)

    ## [1] "2015-10-19 10:15:00 MDT"

    unclass(timeDatelt)

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

When we a string is convered to `POSIXlt`, it still appears to be a date/time 
class. However, `unclass()` shows us that the data are stored differently. The 
`POSIXlt` format stores the hour, minute, second, and month day year as separate 
components.

#something about 0 based indexing - but really i think this is getting into the 
#weeds - it's interesting. Maybe make it a little breakout but it's distracting
#from the lesson.

1) $mon = 9, but October is the 10th month and 
2) $year = 115, not 2015.  
We need to look at the POSIXlt documentation to figure out why this is happening. 


    #help for POSIXlt
    ?POSIXlt

Looking at the details we see that POSIXlt $mon is classified from 0-11 so
October would be the 9th month and $year is the number of years since 1900 so
2015 is year 115.  The unclassed date components are not incorrect, just not
what we expected. 

Having dates classified as seperate components makes this time class a bit more
difficult to use in dataframes and to manipulate, which is why we won't use
POSIXlt for this lesson.  Instead we can specified which format (year-month-day
hour:minute) we wanted to see the date and time when using POSIXct.  This way we 
know what the date is and the program can still work with the date/time in a single format.


############# the above text is too much; getting into the weeds for a beginner ####

##Convert Date Time to a R date/time class 

Let's convert our data to a date/time field. We will use the `as.POSIXct` function.
We can tell R how our data are formated using a `format=` string as follows

* %Y - year
* %m - month
* %d - day
* %H:%M - hours:minutes

<a href="" target="_blank">ADD LINK TO PAGE WHICH EXPLAINS ALL OF THE OPTIONS
for TIME AND DATE FORMAT</a>




    #view one date time entry
    harMet_15Min$datetime[1]

    ## [1] "2005-01-01T00:15"

    #convert single instance to a date/time
    as.POSIXct(harMet_15Min$datetime[1],format="%Y-%m-%dT%H:%M")

    ## [1] "2005-01-01 00:15:00 MST"


#NOTE - MAKE SURE THE DATA ARE IN EST AND NOT UTC. UTC IS OFTEN A DEFAULT

###Convert data.frame field to a date/time class


We now need to specific the time zone. Remember we learned in the
metadata (Lesson 01) that these data were recorded in Eastern Standard Time. For use in R 
we need to look up the name for the timezone in the 'tz' database. You can find the list 
here:

NOTE: You can look up the time zones here: <a href="https://en.wikipedia.org/wiki/List_of_tz_database_time_zones" target="_blank">
timeszones</a>
{ : .notice }

The code for Eastern Standard Time is  `America/New_York`.


    #assign time zone to the field
    as.POSIXct(harMet_15Min$datetime[1],
                format = "%Y-%m-%d %H:%M",
                tz = "America/New_York")

    ## [1] NA

#Reformatting A date/time data.frame field

Now, using the syntax that we learned above, we can reformat the entire datetime 
format into an `R POSIX` class.


    #convert to date-time class
    harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                    format = "%Y-%m-%dT%H:%M",
                                    tz = "America/New_York")
    
    #view format of the newly defined datetime data.frame column 
    str(harMet_15Min$datetime)

    ##  POSIXct[1:376800], format: "2005-01-01 00:15:00" "2005-01-01 00:30:00" ...

##Converting Between Time Formats - Julian days

Next, we will explore how to convert our time field to a different format. Heterogeneous
data often use different time formats. Thus, it is useful to know how to convert.
We will use Julian Days given we have some other data (NDVI) in Julian days that 
we'd like to compare to our data.

Julian days, as R interprets it, is a continuous count of the number of days 
beginning at Jan 1, each year. Thus each year will have up to 365 (non leap year)
or 366 (leap year) days. 

Note: This format can also be called ordinal day or year day, and, occasionally,
Julian day can refer to a numeric count since 1 January 4713 BC.
{ : .notice }

To quickly convert from month, day year to Julian days, can we use `yday`, a 
function from the `lubridate` library.


    # convert to julian days
    # to learn more about it type
    ?yday
    
    harMet_15Min$julian <- yday(harMet_15Min$datetime)  
    #make sure it worked all the way through.  Dataframe was 30 variables so julian should be 31st.
    head(harMet_15Min$julian) 

    ## [1] 1 1 1 1 1 1

    tail(harMet_15Min$julian)

    ## [1] 273 273 273 273 273 274

#NOTE - doing this here doesn't really make sense fully given it removes time.
#i will see what happens in the next lesson.
