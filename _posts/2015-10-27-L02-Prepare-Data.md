---
layout: post
title: "Lesson 2: Prepare your data so you can work with it"
date:   2015-10-23 09:47:03 PDT
authors: "Marisa Guarinello, Megan Jones, Courtney Soderberg"
dateCreated:  2015-10-23 09:47:03 PDT
lastModified: 2015-10-23 09:47:03 PDT
category: Working with Tabular Time Series Data
tags: [module-1]
mainTag: Time-Series-Data
description: "This lesson will teach students how to prepare tabular data for further analysis in R, addressing missing values and date-time formats. Students will also learn how to convert characters to a time class, to convert date-time to Julian day, and how to subset the data into a new data frame."
code1: 
image:
  feature: 
  credit: 
  creditlink: http://www.neoninc.org
permalink: /R/Time-Series-Data/
code2: /R/2015-10-23-Time-Series-Data
comments: true

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
This lesson will teach students how to prepare tabular data for further analysis in R, addressing missing values and date-time formats. Students will also learn how to convert characters to a time class, to convert date-time to Julian day, and how to subset the data into a new data frame.

**R Skill Level:** Intermediate - you've got the basics of `R` down and understand the general structure of tabular data.

<div id="objectives">

<h3>Goals / Objectives</h3>
After completing this activity, you will know how to:
<ol>
<li>Clean data</li>
<li>Convert/transform time formats</li>
<li>Subset data</li>
<li>Examine data structures and types</li>
<li>Use metadata to get more information about input data</li>
</ol>

<h3>Things You'll Need To Complete This Lesson</h3>
Please be sure you have the most current version of `R` and preferably
R studio to write your code.
<h3>R Libraries to Install:</h3>
<ul>
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>

<h4>Data to Download</h4>

Make sure you have downloaded the data that includes the AtmosData folder from the raster and *in situ* collected vegetation structure data provided in this dataset:
<ul>
<li><a href="http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068"" class="btn btn-success"> DOWNLOAD Sample NEON LiDAR data in Raster Format & Vegetation Sampling Data</a></li>
</ul>

<h4>Recommended Pre-Lesson Reading</h4>
None
</div>

## Lesson Two: Prepare your data so you can work with it
We will use basic R and the lubridate package for working with date-time formats. However, there are a few options for working with date-time formats (readr, zoo), which are based on similar concepts, you will be able to use help text to explore those on your own as you choose. 


    # Load packages required for entire script
    library(lubridate)  #working with dates

# Dealing with data gaps
Recall from our metadata that missing values are given an NA. One must always check for missing values in any of the variables one is working with.  Do we have missing values in our data set? An easy way to check for this is the is.na() function. By asking for the sum() of is.na() we can see how many NA / missing values we have. 

    #Check for NA values
    sum(is.na(harMet15$datetime))

    ## Error in eval(expr, envir, enclos): object 'harMet15' not found

    sum(is.na(harMet15$airt))

    ## Error in eval(expr, envir, enclos): object 'harMet15' not found

    sum(is.na(harMet15$prec))

    ## Error in eval(expr, envir, enclos): object 'harMet15' not found

    sum(is.na(harMet15$parr))

    ## Error in eval(expr, envir, enclos): object 'harMet15' not found
As you can see here we have no NA values for within the Date/Time data but we do have NA values in our other variables.  

When you encounter NA or missing values (blank, NAN, etc) in your data you  need to decide at this point how to deal with them.  By default R treats NA values as blanks not as zeros.  This is good as a value of zero (no rain today) is not the same as lack of data (we didn't measure the rain today). 

The way one deals with missing values and data gaps will depend on what type of data is being dealt with, the analysis done, and the significance of the gap or missing value.  The many issues associated with this can be complex and beyond the scope of this lesson.  As recommendations vary on how to deal with the data you should look up what others recommend for the specific data type you are dealing with.  Other resources included 
 1)[LINK http://www.statmethods.net/input/missingdata.html] Quick-R: Missing Data -- R code for dealing with data but not why one should do one technique or another
 2) [LINK] XXX article/ site for general recommendations.  Any classics in ecology? 

How should we deal with it in our case?  As the goal of the our current analysis is to get a good feeling about the general patterns of greening up and browning down we can leave the NAs at this point.  Compared to the full dataset (376,800 data points) the few missing values are not going to interfere with our analysis.  However, it is important to remember that there are null values incase you decide to revisit this data set for a more detailed time-series analysis where the data gap would be a problem.  


##Dealing with date and time
Look back up at the results from str(harMet15) that the 'datetime' is seen as a character type. But to work with this column as a date-time, which is important for the analyses and plotting you will learn, we need to convert it to a time class.

First we will reformat the character format of the 'datetime' column


    #convert from character to time type
    #datetime input looks like this: 2005-01-01T00:15
    
    #1st remove the "T" and replace it with a space
    #gsub() replaces all occurances; sub() just replaces first occurance
    harMet15$datetime <- gsub("T", " ", harMet15$datetime)

    ## Error in gsub("T", " ", harMet15$datetime): object 'harMet15' not found

    #make sure it worked
    head(harMet15)

    ## Error in head(harMet15): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'harMet15' not found

Now we need to convert from a character to a time class. 
In this step we need to specific the time zone. Remember these data were recorded in Eastern Standard Time. For R we need to look up the name for the timezone in the 'tz' database. You can find the list here: https://en.wikipedia.org/wiki/List_of_tz_database_time_zones.
In this database, Eastern Standard Time is called "America/New_York".


    #2nd convert to date-time class
    harMet15$datetime <- as.POSIXct(harMet15$datetime,format = "%Y-%m-%d %H:%M",tz = "America/New_York")

    ## Error in as.POSIXct(harMet15$datetime, format = "%Y-%m-%d %H:%M", tz = "America/New_York"): object 'harMet15' not found

    #make sure it worked
    str(harMet15)

    ## Error in str(harMet15): object 'harMet15' not found

So, what is this POSIXct we used? 

R recognizes two different classes for time: POSIXct and POSIXlt.  POSIXct is easier to use in dataframes and is stored as the number of seconds since 1 January 1970 (negative numbers are used for dates before 1970).  However, for us we are used to seeing dates by day month year and hours of the day not elapsed seconds. POSIXlt instead stores date time information in a more human friendly format we are used to seeing (e.g. second, min, hour, day of month, month, year, numeric day of year, etc). However, this makes it difficult to use in dataframes and to manipulate, which is why we didn't use POSIXlt here.  Instead we specified which format (year-month-day hour:minute) we wanted to see the date and time when using POSIXct.  This way we know what the date is and the programs can still work with the date/time in a single format.  


#Convert to Julian days

In some cases you might want to use Julian days, which gives each day of the year a number starting with 1 on Jan 1 and counting up to 365 or 366 on December 31 depending on if it is a leap year or not. Reasons you might want to convert to Julian days are for smoother plotting and manipulation of data.


    #convert to julian days
    #here we will use yday, which is a function from the lubridate package; to learn more about it type
    ?yday
    harMet15$julian <- yday(harMet15$datetime)  

    ## Error in yday(harMet15$datetime): object 'harMet15' not found

    #make sure it worked
    head(harMet15) 

    ## Error in head(harMet15): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'harMet15' not found

    tail(harMet15)

    ## Error in tail(harMet15): error in evaluating the argument 'x' in selecting a method for function 'tail': Error: object 'harMet15' not found


#Subsetting
To take a smaller subset of data to work with, let's just take 3 years 2009-2011. We need to include the time zone to get this to work correctly.

    #subset out some of the data - 2009-2011
    yr.09.11 <- subset(harMet15, datetime >= as.POSIXct('2009-01-01 00:00', tz = "America/New_York") & datetime <=
    as.POSIXct('2011-12-31 23:45', tz = "America/New_York"))

    ## Error in subset(harMet15, datetime >= as.POSIXct("2009-01-01 00:00", tz = "America/New_York") & : error in evaluating the argument 'x' in selecting a method for function 'subset': Error: object 'harMet15' not found
@Challenge (testing lesson 1 & 2)
1. Import daily .csv and name it harMet.daily
2. Check out the data structure
3. Convert date- time
4. Add a column and calculate julian day


    #import daily file
    harMet.daily <- read.csv("data/AtmosData/HARV/hf001-06-daily-m.csv", stringsAsFactors = FALSE)

    ## Warning in file(file, "rt"): cannot open file 'data/AtmosData/HARV/
    ## hf001-06-daily-m.csv': No such file or directory

    ## Error in file(file, "rt"): cannot open the connection

    #check it out
    str(harMet.daily)

    ## Error in str(harMet.daily): object 'harMet.daily' not found

    head(harMet.daily)

    ## Error in head(harMet.daily): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'harMet.daily' not found

    #convert date
    harMet.daily$date <- as.POSIXct(harMet.daily$date,format = "%Y-%m-%d",tz = "America/New_York")

    ## Error in as.POSIXct(harMet.daily$date, format = "%Y-%m-%d", tz = "America/New_York"): object 'harMet.daily' not found

    #check it out
    str(harMet.daily)

    ## Error in str(harMet.daily): object 'harMet.daily' not found

    head(harMet.daily)

    ## Error in head(harMet.daily): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'harMet.daily' not found

    #add and calc julian day
    harMet.daily$julian <- yday(harMet.daily$date)

    ## Error in yday(harMet.daily$date): object 'harMet.daily' not found

    #check it
    head(harMet.daily)

    ## Error in head(harMet.daily): error in evaluating the argument 'x' in selecting a method for function 'head': Error: object 'harMet.daily' not found

    str(harMet.daily)

    ## Error in str(harMet.daily): object 'harMet.daily' not found
