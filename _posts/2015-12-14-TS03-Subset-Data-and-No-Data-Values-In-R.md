---
layout: post
title: "Lesson 03: Refining Time Series Data -- NoData Values and Subsetting Data
by Date in R"
date: 2015-10-22
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser]
dateCreated: 2015-10-22
lastModified: 2015-12-14
tags: module-1
packagesLibraries: [lubridate, ggplot2]
category: 
description: "This lesson teaches how to prepare tabular data for further analysis in R, addressing missing values and how to subset the data into
a new data frame."
code1: TS03-Subset-Data-and-No-Data-Values-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Subset-Data-and-No-Data-Values
comments: false
---

{% include _toc.html %}

##About
This lesson teaches how to prepare tabular data for further analysis in R, 
addressing missing values and how to subset the data into a new data frame.

**R Skill Level:** Intermediate - you've got the basics of `R` down and 
understand the general structure of tabular data.

<div id="objectives" markdown="1">

### Goals / Objectives
After completing this activity, you will:

 * Be able to subset data by date. 
 * Know how to search for NA or missing data values. 
 * Understand different possibilities on how to deal with missing data. 

###Challenge Code
Throughout the lesson we have Challenges that reinforce learned skills. Possible
solutions to the challenges are not posted on this page, however, the code for
each challenge is in the `R` code that can be downloaded for this lesson (see
footer on this page).

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and, preferably,
RStudio to write your code.

####R Libraries to Install
<li><strong>lubridate:</strong> <code> install.packages("lubridate")</code></li>
<li><strong>ggplot2:</strong> <code> install.packages("ggplot2")</code></li>

  <a href="http://neondataskills.org/R/Packages-In-R/" target="_blank">
More on Packages in R - Adapted from Software Carpentry.</a>

####Data to Download

<a href="https://ndownloader.figshare.com/files/3579861" class="btn btn-success">
Download Atmospheric Data</a>

The data used in this lesson were collected at Harvard Forest which is
an National Ecological Observatory Network  
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank"> field site</a>. These data are proxy data for what will be available for 30 years on the [NEON data portal](http://data.neoninc.org/ "NEON data")
for both Harvard Forest and other field sites located across the United States.


####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory/ "R Working Directory Lesson") lesson prior to beginning
this lesson.

###Time Series Lesson Series 
This lesson is a part of a series of lessons on tabular time series data in `R`:

* [ Brief Time Series in R - Simple Plots with qplot & as.Date Conversion]({{ site.baseurl}}/R/Brief-Tabular-Time-Series-qplot/)
* [Understanding Time Series Metadata]({{ site.baseurl}}/R/Time-Series-Metadata/)
* [Convert Date & Time Data from Character Class to Date-Time Class (POSIX) in R]({{ site.baseurl}}R/Time-Series-Convert-Date-Time-Class-POSIX/)
* [Refining Time Series Data - NoData Values and Subsetting Data by Date in R]({{ site.baseurl}}/R/Subset-Data-and-No-Data-Values/)
* [Subset and Manipulate Time Series Data with dplyr]({{ site.baseurl}}/R/Time-Series-Subset-dplyr/)
* [Plotting Time Series with ggplot in R]({{ site.baseurl}}/R/Time-Series-Plot-ggplot/)
* [Plot uisng Facets and Plot Time Sereis with NDVI data]({{ site.baseurl}}/R/Time-Series-Plot-Facets-NDVI/)
* [Converting to Julian Day]({{ site.baseurl}}/R/julian-day-conversion/)

###Sources of Additional Information

</div>

#The Data Approach
We'll learn now how to subset data and how to find and deal with missing data 
values, while we continue to explore the relationship between our variables of
interest, air temperature, precipitation, and photosynthetically active
radiation (PAR) in regards to plant phenology.  

Prior to starting we need to load the appropriate libraries (`lubridate` and
`ggplot2`).  If you have not already done so, we must also load the .csv file for
15-minute micrometeorological data ( file: `hf001-10-15min-m.csv`) and convert 
the `datetime` column to a POSIXct class date-time data type. 


    # Load packages required for entire script
    library(lubridate)  #work with dates
    library(ggplot2)  # plotting
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")
    
    #Load csv file of 15 min meteorological data from Harvard Forest
    #Factors=FALSE so strings, series of letters/ words/ numerals, remain characters
    harMet_15Min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
                         stringsAsFactors = FALSE)
    #convert date time
    harMet_15Min$datetime <- as.POSIXct(harMet_15Min$datetime,
                                    format = "%Y-%m-%dT%H:%M",
                                    tz = "America/New_York")

##Subsetting
Our `.csv` file contains nearly a decade's worth of data which makes for a large
file. The time period we are interested in for our study is only 2009-2011. We
can subset the data so that we have just these three years.

To to this we will use the `subset()` function, with the syntax
`NewObject <- subset ( ObjectToBeSubset, CriteriaForSubsetting ) `.  

In our new data frame, want all data between the beginning of 1 January 2009 and
the end of 31 December 2011, so we set our criteria to be "any `datetime` that
is greater than
or equal to 1 Jan 2009 at 0:00 **AND** less than or equal to 31 Dec 2011 at
23:59".

We need to include the time zone to get this to work correctly. If we provide
the time zone, `R` will take care of daylight savings and leap year for us.


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

It worked! The first entry is 1 January 2009 at 00:00 and the last entry is 31
December 2011 at 23:45.

Sometimes we might want to share just a subset of our data with a colleague.  We 
can do that by writing our new `R` object to a .csv file.  Remember, that
when naming any file, give it a concise, yet description name.  By default, the
the .csv file will be written to your working directory. 


    #writing the subset of harMet15 data to .csv
    write.csv(harMet15.09.11, file="Met_HARV_15min_2009_2011.csv")


#Challenge: Subsetting & Plotting
1.Plot precipitation for only July 2010 in the Harvard Forest
 
![ ]({{ site.baseurl }}/images/rfigs/TS03-Subset-Data-and-No-Data-Values-In-R/challenge-code-subsetting-1.png) 


## Missing Data - Dealing with data gaps

###Checking for No Data Values
In the [Time Series Metadata Lesson ]({{site.baseurl}}/R/Time-Series-Metadata/ "Time Series Metadata")
we viewed the metadata associated 
with these data and found out that the missing values are given an NA value. One 
must always check for missing values in any of the variables with which one is 
working.  

Do we have missing values in our data set? 

An easy way to check for this is the
`is.na()` function. By asking for the `sum()` of `is.na()` we can see how many 
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

As we can see here we have no NA values within the `datetime` column but we do
have NA values in our other variables.  

###Dealing with No Data Values
When we encounter NA or missing values (blank, NaN, -9999, etc.) in our data we
need to decide how to deal with them.  By default `R` treats NA values as 
blanks, not as zeros.  This is good, as a value of zero (no rain today) is not
the same as lack of data (we didn't measure the rain today). 

Beware--some .csv files use blank to indicate 'zero', this is why checking the 
metadata is essential!

The way one deals with missing values and data gaps will depend on what type of 
data are used, the analysis conducted and the significance of the gap or 
missing value.  The many issues associated with this can be complex and are 
beyond the scope of this lesson.  As recommendations vary on how to deal with 
missing data you should look up what others recommend for the specific type of 
data you are using and the analyses you plan.  Other resources included:

1. <a href="http://www.statmethods.net/input/missingdata.html" target="_blank"> Quick-R: Missing  Data</a> 
 -- R code for dealing with missing data 
2. The Institute for Digital Research and Education has an <a href="http://www.ats.ucla.edu/stat/r/faq/missing.htm" target="_blank"> R FAQ on Missing Values</a>.

How should we deal with the missing values in our case?  As the goal of the our 
current analysis
is to get a good feeling about the general patterns of greening up and browning 
down we can leave the NAs in the different variables at this point. With no 
missing values in the `datetime` column, the x-axis on our plots will not be 
missing values.  Compared to the full dataset (376,800 data points) the few 
missing values in the other variables are not going to interfere with us seeing 
general trends.

However, it is important to remember that there are null values in case we 
decide to revisit this data set for a more detailed time-series analysis where 
the data gap would be a problem.  

###NA Values in Functions & Calculations
One time it is very important to consider NA values is if we are doing 
calculations
or using a function on columns that may contain NA values.  Missing values can
cause error in calculations.  By default `R` will not calculate certain function
if they have a NA value in it.  

    #calculate mean of air temperature
    mean(harMet15.09.11$airt)

    ## [1] NA

`R` will not return a value for the mean as there NA values in the air 
temperature.  However, we know that there are only 2 of 105,108 observations of 
air temperature missing, so we aren't that worried about those two missing values
skewing the three year air temperature mean.  We can tell `R` to not include the
missing values by using `na.rm=` (NA.remove) within the function.  


    #calculate mean of air temperature, ignore NA values
    mean(harMet15.09.11$airt, na.rm=TRUE)

    ## [1] 8.467904

We now see that the average air temperature across the three years was 8.5°C.  

# Challenge: Import, Understand Metadata, and Clean a Data Set
We have been using the 15-minute data from the Harvard Forest. However, overall
we are interested in larger scale patterns of greening-up and browning-down.  
Daily atmospheric data are therefore far more appropriate for our work than the 
15-minute data.  

1. Import the Daily Meteorological data from the Harvard Forest (if you haven't already done so in the [Brief Tabular Time Series lesson ]({{site.baseurl}}/R/Brief-Tabular-Time-Series-qplot/ "for HarMet_Daily"). )
2. Check the metadata to see what the column names are for the variable of
interest (precipitation, air temperature, PAR, day and time ).
3. If needed, convert the data class of different columns.
4. Check for missing data and decide what to do with any that exist.
5. Subset out the data for the duration of our study: 2009-2011. Name the object 
"harMetDaily.09.11" for consistency with later lessons. Be sure to recheck the 
quality of the data at this point. 
6. Write the subset to a .csv file. 
7. Create a fully labelled plot for the air temperature during our study. 

![ ]({{ site.baseurl }}/images/rfigs/TS03-Subset-Data-and-No-Data-Values-In-R/Challenge-code-harMet.daily-1.png) 

