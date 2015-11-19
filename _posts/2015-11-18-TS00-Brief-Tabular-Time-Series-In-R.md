---
layout: post
title: "Lesson 00: Brief Time Series in R"
date:   2015-10-25
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser]
dateCreated:  2015-10-22
lastModified: 2015-11-19
packagesLibraries: [ggplot2]
category: 
tags: [module-1]
description: "This lesson will demonstrate how to import a time series dataset 
stored in .csv format into R. It will explore column formats and will walk
through how to convert a date field, stored as a character string, into a date 
field that R can recogniaze and plot efficiently."
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Introduction-to-Tabular-Time-Series-In-R
comments: false
---

{% include _toc.html %}

##About
This lesson will demonstrate how to import a time series dataset stored in .csv
format into R. It will explore column formats and will walk through how to 
convert a date field, stored as a character string, into a date field that R can
recogniaze and plot efficiently.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this lesson, you will:

  * Be able to open a .csv file in `R` using `read.csv()`.
  * Understand how to work with `date.frame` fields in `R`.
  * Understand how to examine data structures and types.
  * Be able to convert a date field, stored as a character, into an `R` date 
  format.
  * Know how to create a quick plot of a time-series dataset using `qplot` 

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
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
field site</a>. These data are proxy data for what will be available for 30 years
on the [NEON data portal](http://data.neoninc.org/ "NEON data")
for both Harvard Forest and other field sites located across the United States.

####Setting the Working Directory
The code in this lesson assumes that you have set your working directory to the
location of the unzipped file of data downloaded above.  If you would like a 
refresher on setting the working directory, please view the <a href="XXX" target="_blank">Setting A Working Directory In R</a> lesson prior to beginning the lesson.  
</div>

#The Data Approach

In this lesson, we will explore micro-meterology data collected from a 
<a href="http://www.neoninc.org/science-design/collection-methods/flux-tower-measurements" target="_blank">flux
tower</a> at the NEON Harvard Forest field site. We are interested in exploring 
patterns associated with changes in temperature, precipitation, PAR and day 
length -- metrics that impact changes in plant <a href=" http://budburst.org/phenology_defined" target="_blank">phenology</a>. 


#About .csv File Format

We have received micro-meterology data from a flux tower at Harvard Forest in
`.csv` format.
The file extension `.csv` stands for comma separated values. It is a text file 
based format, where each value in the dataset is separate by a comma. Plain text 
formats are ideal for working both across platforms (MAC, PC, LINUX, etc) and 
also can be read by many different tools. Additionally, the file format is 
less likely to become obsolete over time!

<a href="https://en.wikipedia.org/wiki/Comma-separated_values" target="_blank"> For more on .csv format see this Wikipedia article</a>

Our `.csv` file contains a suite of metrics that we are interested in. To begin 
exploring  the data, we need to first import it into R. We can use the function 
`read.csv` to import the data. We can then explore the data structure.

> Bonus: Good coding practice -- install and load all libraries at top of script.
> If you decide you need another package later on in the script, return to this
> area and add it.  That way, with a glance, you can see all packages
> used in a given script. 


    # Install packages required for entire script.
    #install.packages(ggplot2)
    
    # Load libraries required for entire script. 
    # library(nameOfLibrary)  #purpose of library
    library(ggplot2)   #efficient, pretty plotting - required to qplot function
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")

Once our working directory is set, we can import the data using 
`read.csv`. 

##stringsAsFactors
When reading in files we will use `stringsAsFactors = FALSE`. This additon
causes `R` to read non-numeric data (strings) in their original format and not
convert them to factors.  Factors are non-numerical data that can be numerically 
interpreted and may have a level associated with them. 

Examples of factors:

* names of the months (an ordinal variable). They are non-numerical but we know 
that April comes after March and each could be represented by 4 and 3 
respectively.
* 1 and 2s to represent male and female sex (a nominal variable). Numerical
interpretation of non-numerical data but no order to the levels.  

But much of our data are not suitable for factors. An example of strings as
non-factors are a hypothetical data set of`SpeciesObserved` consisting of 
*mouse*, *grasshopper*, and *sparrow*. These are non-numerical data with no 
relevant level or numerical interpretation.  

It is easy to turn specific colums into factors later on using `as.factor()`,
so it is almost always best to read in a file with `stringsAsFactors = FALSE`.


    #Load csv file of daily meterological data from Harvard Forest
    harMetdaily <- read.csv(file="AtmosData/HARV/hf001-06-daily-m.csv",
                         stringsAsFactors = FALSE)
    
    #what type of R object is our imported data?
    class(harMetdaily)

    ## [1] "data.frame"

#Data.Frames in R
When we use the `read.csv()` function, `R` imports the data as a `data.frame`.
This format type is idea for working with tabular data. It is similar to a 
spreadsheet.

## Data Structure & Metadata
Once our data are imported, we can explore its structure. There are several ways to examine the structure of a data frame: 

* `head()` method: this will show us the first 6 rows of the data. 
* `str()` method: view the structure of the data as `R` interprets it.

Let's view each. 


    #view first 6 rows of the dataframe 
    head(harMetdaily)

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
    str(harMetdaily)

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

##Data Types in R

The structure of our data tells us that the data are stored as several different
data types or classes in our `.csv`:

* **chr** - Character. It holds strings that are data made up of letters and
words.  They are not of a numerical interpretation and most often represent data
that are discrete classes.  
* **int** - Integer.  It holds numbers that are whole integers without decimals.
* **num** - Numeric.  It accepts data that are a wide variety of numbers 
including decimals and integers. Numeric also accept larger numbers than **int**
will (>2*10^9).

Storing variables as different data types is a strategic decision by `R` (and 
other programing languages).  Certain functions can be performed on certain data
types and not on others (e.g. a<-"mouse"-"sparrow"; subtracting two **chr** data
points makes no sense).  Additionally, the attributes and properties of
different data types varies (e.g. there is not point in showing the minimum
value for `SpeciesObserved` a **chr** type but there is for `prec` a **num**
type.) These and many other processes mean that assigning data types makes for
more efficient and faster running code. 

#Plot Data Using qplot

Let's have a look at one of the metrics, stored within our data -- `airt` which 
is air temperature. Given this is a time series dataset, we might want to plot
air temperature as it changes over time. We have a date time field so let's use
that as our x-axis variable, `airt` will be our y-axis variable.

We will use the `qplot()` (for *quick plot*) function in the `ggplot2` library.
The notation for `qplot` requires the x- and y-axis variables and then the R
object that the variables are stored in. 


    #quickly plot of air temperature
    qplot(x=date,y=airt, data=harMetdaily)

![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/plot-data-1.png) 

We have successfully plotted some data. However, what is going happening on the 
x-axis?

R is trying to plot EVERY date value on the x-axis, so it was not readable. Why?
Let's have a look at the format of the fields that we are trying to plot.


    # View data structure for each column that we wish to plot
    class(harMetdaily$date)

    ## [1] "character"

    class(harMetdaily$airt)

    ## [1] "numeric"

Looking at our data, we can see that the `date` field actually imported into
`R` as character type. This means that `R` does not know how to plot these 
data as a continuous variable on the x-axis. The `airt` field is numeric so that
field should plot just fine.

#Date as a Time Format
We need to convert our date field, which is currently stored as a character 
value to an actual date format that can be displayed quantitively. Lucky for us, `R` has `date` format. We can reassign the `harMetdaily$date` field using `as.Date`.


    #convert field to date format
    harMetdaily$date <- as.Date(harMetdaily$date)
    
    #view results
    head(harMetdaily$date)

    ## [1] "2001-02-11" "2001-02-12" "2001-02-13" "2001-02-14" "2001-02-15"
    ## [6] "2001-02-16"

    #view structure of field
    class(harMetdaily$date)

    ## [1] "Date"

Now that we have adjusted the date, let's plot again. Notice that it plots
much more quickly now that R recognizes the date as a date field. R can agregate
ticks on the x axis by year instead of trying to plot every day!


    #quickly plot the data and include a title
    #In a string \n forces the string to break onto a new line
    qplot(x=date,y=airt, 
          data=harMetdaily,
          main="Daily Air Temperature w Date Assigned\nNEON Harvard Forest")  

![ ]({{ site.baseurl }}/images/rfigs/TS00-Brief-Tabular-Time-Series-In-R/qplot-data-1.png) 


#Challenge
> 1. Plot something else?? what else should we plot.
> 2. it could be cool to show them how to aggregate - adjust tick marks by 5 years, 10 years, etc
> 3. it could be cool to show them how to add x lab and y lab
> 4. plot on variable vs another??



