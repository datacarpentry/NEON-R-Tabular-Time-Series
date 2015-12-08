---
layout: post
title: "Lesson 00: Brief Time Series in R - Simple Plots with qplot & as.Date
Conversion"
date:   2015-10-25
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser]
dateCreated:  2015-10-22
lastModified: 2015-12-08
packagesLibraries: [ggplot2]
category: 
tags: [module-1]
description: "This lesson will demonstrate how to import a time series data set 
stored in .csv format into `R`. It will explore data classes and will walk
through how to convert date data, stored as a character string, into a date 
class that R can recognize and plot efficiently."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Brief-Tabular-Time-Series-qplot
comments: false
---

{% include _toc.html %}

##About
This lesson will demonstrate how to import a time series data set stored in .csv
format into `R`. It will explore column data classes and will walk through how to 
convert a date, stored as a character string, into a date class that R can
recognize and plot efficiently.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this lesson, you will:

  * Be able to open a .csv file in `R` using `read.csv()`and understand why we
  are using that file type.
  * Understand how to work with different columns within a `data.frame` in `R`.
  * Understand how to examine data structures and data classes.
  * Be able to convert date data, stored as a character, into an `R` date 
  class.
  * Know how to create a quick plot of a time-series data set using `qplot`. 

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of 'R' and, preferably,
RStudio to write your code.

####R Libraries to Install

* **ggplot:** `install.packages("ggplot2")`

 <a href="http://neondataskills.org/R/Packages-In-R/" target="_blank">
More on Packages in R - Adapted from Software Carpentry.</a>

####Data to Download

<a href="http://files.figshare.com/2437700/AtmosData.zip" class="btn btn-success">
Download Atmospheric Data</a>

The data used in this lesson were collected at Harvard Forest which is
an National Ecological Observatory Network  
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank"> field site</a>. 
These data are proxy data for what will be available for 30 years
on the [NEON data portal](http://data.neoninc.org/ "NEON data")
for both Harvard Forest and other field sites located across the United States.

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a
refresher on setting the working directory, please view the [Setting A Working Directory In R]({{site.baseurl}}/R/Set-Working-Directory "R Working Directory Lesson") lesson prior to beginning
this lesson.

</div>

#The Data Approach

In this lesson, we will explore micro-meteorology data collected from a 
<a href="http://www.neoninc.org/science-design/collection-methods/flux-tower-measurements" target="_blank">flux
tower</a> at the NEON Harvard Forest field site. We are interested in exploring 
patterns associated with changes in temperature, precipitation, PAR and day 
length -- metrics that impact changes in plant <a href=" http://budburst.org/phenology_defined" target="_blank">phenology</a>. 


#About .csv File Format
The data we downloaded is micro-meteorology data from a flux tower at Harvard
Forest in .csv file format.
The file extension .csv stands for comma-separated values. It is a text file 
based format, where each value in the dataset is separate by a comma. Plain text 
formats are ideal for working both across platforms (Mac, PC, LINUX, etc) and 
also can be read by many different tools. Additionally, the file format is 
less likely to become obsolete over time!

<a href="https://en.wikipedia.org/wiki/Comma-separated_values" target="_blank"> For more on .csv format see this Wikipedia article</a>


# Importing the Data 

Our .csv file contains a suite of metrics that we are interested in. To begin 
exploring  the data, we need to first import it into `R`. 

Bonus: Good coding practice -- install and load all libraries at top of script.
If you decide you need another package later on in the script, return to this
area and add it.  That way, with a glance, you can see all packages used in a
given script. {: .notice2}

We will be using the package `ggplot2` to create basic plots of our
meteorological data. 


    # Install packages required for entire script.
    install.packages("ggplot2")

    ## Installing package into '/Users/mjones01/Library/R/3.2/library'
    ## (as 'lib' is unspecified)

    ## 
    ## The downloaded binary packages are in
    ## 	/var/folders/0p/x8phw1_156511_jqkryx2t8m2vn2t3/T//RtmpXHS0C1/downloaded_packages

    # Load packages required for entire script. 
    # library(PackageName)  #purpose of package
    library(ggplot2)   #efficient, pretty plotting - required for qplot function
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")

Once our working directory is set, we can import the data using `read.csv()`. 


    #Load csv file of daily meteorological data from Harvard Forest
    harMet.daily <- read.csv(file="AtmosData/HARV/hf001-06-daily-m.csv",
                         stringsAsFactors = FALSE)

##stringsAsFactors=FALSE
When reading in files we most often use `stringsAsFactors = FALSE`. This
addition causes `R` to read non-numeric data (strings) in their original format 
and not convert them to factors.  Factors are non-numerical data that can be 
numerically interpreted and may have a level associated with them. 

Examples of factors:

* names of the months (an ordinal variable). They are non-numerical but we know 
that April comes after March and each could be represented by 4 and 3 
respectively.
* 1 and 2s to represent male and female sex (a nominal variable). Numerical
interpretation of non-numerical data but no order to the levels.  

But many types of ecological data are not suitable for factors. An example of
strings as non-factors are a hypothetical data set of `SpeciesObserved` 
consisting of 
*mouse*, *grasshopper*, and *sparrow*. These are non-numerical data with no 
relevant level or numerical interpretation.  

After loading the data it is easy to convert any data that should be a factor by
using `as.factor()`, so it is almost always best to read in a file with
`stringsAsFactors = FALSE`.

#Data.Frames in R
When we use the `read.csv()` function, `R` imports the data as a `data.frame`.
This data class type is ideal for working with tabular data. It is similar to a 
spreadsheet.


    #what type of R object is our imported data?
    class(harMet.daily)

    ## [1] "data.frame"

## Data Structure
Once our data are imported, we can explore its structure. There are several ways
to examine the structure of a data frame: 

* `head()`: shows us the first 6 rows of the data (`tail()` shows the last 6 
            rows). 
* `str()` : displays the structure of the data as `R` interprets it.

Let's view each. 


    #view first 6 rows of the dataframe 
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
    ##   s10tmax f.s10tmax s10tmin f.s10tmin
    ## 1      NA         M      NA         M
    ## 2      NA         M      NA         M
    ## 3      NA         M      NA         M
    ## 4      NA         M      NA         M
    ## 5      NA         M      NA         M
    ## 6      NA         M      NA         M

    #View the structure (str) of the data 
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

##Data Classes in R

The structure of our data tells us that the data are stored as several different
data types or classes in our new `R` object:

* **chr** - Character. It holds strings that are data made up of letters and
words.  They are not of a numerical interpretation and most often represent data
that are discrete categories.  
* **int** - Integer.  It holds numbers that are whole integers without decimals.
* **num** - Numeric.  It accepts data that are a wide variety of numbers 
including decimals and integers. Numeric also accept larger numbers than **int**
will.

Storing variables as different data types is a strategic decision by `R` (and 
other programing languages).  The goal of having different data classes is to 
optimize the data:  

* so it can be processed more quickly & efficiently.
* to minimize the storage size.

Certain functions can be performed on certain data
classes and not on others. 

a <- "mouse"-"sparrow"; subtracting two **chr** data points makes no sense

Additionally, the attributes and properties of
different data classes vary (e.g., there is not point in showing the minimum
value for `SpeciesObserved`, a **chr** type, but there is for `prec` a **num**
type.)  


#Plot Data Using qplot()

Let's have a look at one of the metrics in our data, air temperature -- `airt`.
Given this is a time series dataset, we might want to plot
air temperature as it changes over time. We have a date-time column, `date`, so 
let's use that as our x-axis variable and `airt` will be our y-axis variable.

We will use the `qplot()` (for *quick plot*) function in the `ggplot2` package.
The notation for `qplot()` requires the x- and y-axis variables and then the R
object that the variables are stored in. 


    #quickly plot of air temperature
    qplot(x=date,y=airt, data=harMet.daily)

![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/plot-data-1.png) 

We have successfully plotted some data. However, what is going happening on the 
x-axis?

R is trying to plot EVERY date value on the x-axis, so it was not readable. Why?
Let's have a look at the data class of the data that we are trying to plot.


    # View data structure for each column that we wish to plot
    class(harMet.daily$date)

    ## [1] "character"

    class(harMet.daily$airt)

    ## [1] "numeric"

Looking at our data, we can see that the `date` data actually imported into
`R` as character type. This means that `R` does not know how to plot these 
data as a continuous variable on the x-axis. The `airt` data is numeric so that
data plots just fine.

#Date as a Date-Time Class
We need to convert our `date` data, which is currently stored as a character 
to an actual date-time class that can be displayed quantitatively. Lucky 
for us, `R` has a `date` class.  We can reassign the `date` class using
`as.Date`.


    #convert column to date class
    harMet.daily$date <- as.Date(harMet.daily$date)
    
    #view R class of data
    class(harMet.daily$date)

    ## [1] "Date"

    #view results
    head(harMet.daily$date)

    ## [1] "2001-02-11" "2001-02-12" "2001-02-13" "2001-02-14" "2001-02-15"
    ## [6] "2001-02-16"

Now that we have adjusted the date, let's plot again. Notice that it plots
much more quickly now that R recognizes `date` as a date class. `R` can 
aggregate ticks on the x-axis by year instead of trying to plot every day!


    #quickly plot the data and include a title using main=""
    #In title string we can use '\n' to force the string to break onto a new line
    qplot(x=date,y=airt, 
          data=harMet.daily,
          main="Daily Air Temperature w/ Date Assigned\nNEON Harvard Forest")  

![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/qplot-data-1.png) 

Note that we have also added a title using `main="Title string"`.

#Challenge: Using ggplot2's qplot function 
1. Create a quick plot of the precipitation throughout all years of the study.
2. Do precipitation and air temperature have similar annual patterns? 
3. Create a quick plot examining the relationship between air temperature and precipitation. 

![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/challenge-code-plotting-1.png) ![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/challenge-code-plotting-2.png) 

