---
layout: post
title: "Lesson 06: Create Plots with Multiple Panels, Grouped by Time Using ggplot
Facets"
date:   2015-10-19
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg, Leah Wasser]
contributors: [ ]
dateCreated: 2015-10-22
lastModified: 2016-01-08
packagesLibraries: [ggplot2, scales, gridExtra, grid, dplyr, reshape2]
category:  
tags: [spatio-temporal, time-series, phenology, R]
mainTag: time-series
description: "This lesson teaches how to plot subsetted time series data using
the facets() function (e.g., plot by season) and to plot time series data with
NDVI."
code1: TS06-Plotting-Facets-And-Group-By-Time-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: R/Time-Series-Plot-Facets-NDVI
comments: false
---

{% include _toc.html %}

##About
This lesson teaches how to plot subsetted time series data using
the `facets()` function (e.g., plot by season) and to plot time series data with
NDVI.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

###Goals / Objectives
After completing this activity, you will:

 * Know how to use `facets()` in the ggplot2 package.
 * Be able to combine different types of data into one plot.

##Things You’ll Need To Complete This Lesson
To complete this lesson: you will need the most current version of R, and 
preferably RStudio, loaded on your computer.

###Install R Packages
* **ggplot2:** `install.packages("ggplot2")`
* **scales:** `install.packages("scales")`
* **gridExtra:** `install.packages("gridExtra")`
* **grid:** `install.packages("grid")`
* **dplyr:** `install.packages("dplyr")`
* **reshape2:** `install.packages("reshape2")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

###Download Data 
{% include/dataSubsets/_data_Met-Time-Series.html %}

****

{% include/_greyBox-wd-rscript.html %}

**Tabular Time Series Lesson Series:** This lesson is part of a lesson series on 
[tabular time series data in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series). 
It is also part of a larger 
[spatio-temporal Data Carpentry workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop)
that includes working with
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series) 
and  
[vector data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-vector-series).

****

##Skills Needed
This lessons assumes familiarity with both the `dplyr` package and `ggplot()` in
the `ggplot2` package.  If you are not comfortable with either of these we
recommend starting with the
[Subset & Manipulate Time Series Data with dplyr lesson]({{site.baseurl}}/R/Time-Series-Subset-dplyr/ "Learn dplyr") 
and the 
[Plotting Time Series with ggplot in R lesson]({{site.baseurl}}/R/Time-Series-Plot-ggplot/ "Learn ggplot")  
respectively, to gain familiarity.

</div>

#Plotting Subsetted Data Using Facets
 
In this lesson we will learn how to create a panel of individual plots - known as
facets in `ggplot2`. Each plot represents a particular `data_frame` time-series 
subset - for example year or season.

###Load the Data
We will use the daily micro-meteorology data for 2009-2011 from the Harvard
Forest. If you do not have this data loaded into an `R` `data_frame`, please 
load them, and convert date-time columns to a date-time class now.


    #Remember it is good coding technique to add additional libraries to the top of
      #your script 
    library(lubridate) #for working with dates
    library(ggplot2)  #for creating graphs
    library(scales)   #to access breaks/formatting functions
    library(gridExtra) #for arranging plots
    library(grid)   #for arrangeing plots
    library(dplyr)  #for subsetting by season
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")
    
    #daily HARV met data, 2009-2011
    harMetDaily.09.11 <- read.csv(
      file="NEON-DS-Met-Time-Series/HARV/FisherTower-Met/Met_HARV_Daily_2009_2011.csv",
      stringsAsFactors = FALSE
      )
    
    #covert date to POSIXct date-time class
    harMetDaily.09.11$date <- as.POSIXct(harMetDaily.09.11$date)

##ggplot2 Facets

Facets allow us to plot subsets of data in one cleanly organized panel. We use
`facet_grid()` to create a plot of a particular variable subsetted by a
particular *group*.
 
Let's plot air temperature as we did previously. We will name the `ggplot`
object `AirTempDaily`.


    AirTempDaily <- ggplot(harMetDaily.09.11, aes(date, airt)) +
               geom_point() +
               ggtitle("Daily Air Temperature\n NEON Harvard Forest\n 2009-2011") +
                xlab("Date") + ylab("Temperature (C)") +
                scale_x_datetime(labels=date_format ("%m-%y"))+
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    AirTempDaily

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-airt-1.png) 
 
This plot tells us a lot about the annual increase and decrease of temperature
at the NEON Harvard Forest field site. However, what is we wanted to plot each
year's worth of data individually?

If we use the `facet()` element in `ggplot`, we can create facets or a panel of 
plots that are grouped by a particular category or time period. To create a 
a plot for each year, we will first need a year column in our data to use a
subset factor. We created a year column did this in the 
[{{site.baseurl}}R/Time-Series-Subset-dplyr/](dplyr subset timeseries lesson)
using the `year` function in the `lubridate` package.


    #add year column to daily values
    harMetDaily.09.11$year <- year(harMetDaily.09.11$date)
    
    #view year column head and tail
    head(harMetDaily.09.11$year)

    ## [1] 2009 2009 2009 2009 2009 2009

    tail(harMetDaily.09.11$year)

    ## [1] 2011 2011 2011 2011 2011 2011

## Facet by Year
Once we have a column that can be used to group or subset our data, we can 
create a faceted plot - plotting each year's worth of data in an individual, 
named panel.


    #run this code to plot the same plot as before but with one plot per season
    AirTempDaily + facet_grid(. ~ year)

    ## Error in layout_base(data, cols, drop = drop): At least one layer must contain all variables used for facetting

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-facet-year-1.png) 

Oops - what happened? The plot did not render because we added the `year` column
after creating the `ggplot` object `AirTempDaily`. Let's rerun the `ggplot` code
to ensure our newly added column is recognized.


    AirTempDaily <- ggplot(harMetDaily.09.11, aes(date, airt)) +
               geom_point() +
               ggtitle("Daily Air Temperature\n NEON Harvard Forest\n 2009-2011") +
                xlab("Date") + ylab("Temperature (C)") +
                scale_x_datetime(labels=date_format ("%m-%y"))+
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    #facet plot by year
    AirTempDaily + facet_grid(. ~ year)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-facet-year-2-1.png) 

The faceted plot is interesting, however the x-axis on each plot is
month-day-year. This means that the data for 2009 is on the left end of the plot
and the data for 2011 is on the right end (the end of the x axis) of the 2011
plot. Our plots might be easier to compare visually, if the days were Julian
days rather than date. 


    AirTempDaily_jd <- ggplot(harMetDaily.09.11, aes(jd, airt)) +
               geom_point() +
               ggtitle("Daily Precipitation\n 2009-2011\n NEON Harvard Forest") +
                xlab("Julian Day") + ylab("Temperature (C)") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    #create faceted panel
    AirTempDaily_jd + facet_grid(. ~ year)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-precip-jd-1.png) 

Using Julian day, our plots are visually easier to compare. Arranging our plots 
this way, side by side, allows us to quickly scan for differences along the
y-axis. Notice any differences in min vs max air temperature across the three
years?

##Arrange Facets

We can rearrange the facets in different ways, too.


    #move labels to the RIGHT and stack all plots
    AirTempDaily_jd + facet_grid(year ~ .)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/rearrange-facets-1.png) 

If we use `facet_wrap` we can specify the number of columns.


    #add columns
    AirTempDaily_jd + facet_wrap(~year, ncol = 2)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/rearrange-facets-columns-1.png) 

##Graph Two Variables on One Plot
Next, let's explore the relationship between two variables - air temperature
and soil temperature. We might expect soil temperature to fluctuate with changes
in air temperature over time.  

We will use `ggplot()` to plot `airt` and `s10t` (soil temperature 10 cm below
the ground). 


    airSoilTemp_Plot <- ggplot(harMetDaily.09.11, aes(airt, s10t)) +
               geom_point() +
               ggtitle("Air vs. Soil Temperature\n NEON Harvard Forest Field Site\n 2009-2011") +
               xlab("Air Temperature (C)") + ylab("Soil Temperature (C)") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    airSoilTemp_Plot

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-airt-soilt-1.png) 

The plot above suggests a relationship between the air and soil temperature as
we might expect. However, it clumps all three years worth of data into one plot. 
Let's create a stacked faceted plot of air vs. soil temperature grouped by year.

Lucky for us, we can do this quickly with one line of code - reusing the plot we
created above.


    #create faceted panel
    airSoilTemp_Plot + facet_grid(year ~ .)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/faceted-temp-plots-1.png) 

Have a close look at the data. Are there any noticeable min / max temperature 
differences between the three years?

<div id="challenge" markdown="1">
##Challenge: Faceted Plot
Create a faceted plot of air temperature vs soil temperature by *month* rather 
than year.

HINT: To create this plot, you will want to add a month column to our
`data_frame`. We can use lubridate `month` in the same way we used `year` to add
a year column. 

</div>

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/challenge-answer-temp-month-1.png) 

##Faceted Plots & Categorical Groups

In the challenge above, we grouped our data by *month* - specified by a numeric
value between 1 (January) and 12 (December). However, what if we wanted to 
organize our plots using a categorical (character) group such as month NAME?
Let's do that next.

If we want to group our data by month *name*, we first need to create a month name
column in our `data_frame`. We can create this column using the following
syntax:

`format(harMetDaily.09.11$date,"%B")`, 

which tells `R` to extract the month name (`%B`) from the date field.


    #add text month name column
    harMetDaily.09.11$month_name <- format(harMetDaily.09.11$date,"%B")
    
    #view head and tail
    head(harMetDaily.09.11$month_name)

    ## [1] "January" "January" "January" "January" "January" "January"

    tail(harMetDaily.09.11$month_name)

    ## [1] "December" "December" "December" "December" "December" "December"

    #recreate plot
    airSoilTemp_Plot <- ggplot(harMetDaily.09.11, aes(airt, s10t)) +
               geom_point() +
               ggtitle("Air vs. Soil Temperature \n NEON Harvard Forest Field Site\n 2009-2011") +
                xlab("Air Temperature (C)") + ylab("Soil Temperature (C)") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    #create faceted panel
    airSoilTemp_Plot + facet_wrap(~month_name, nc=3)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/extract-month-name-1.png) 

Great! We've created a nice set of plots by month. However, what is the order
or the plots? It looks like `R` is ordering things alphabetically yet we know
that months are ordinal not character strings. To account for order, we can 
reassign the `month_name` field to a `factor`. This will allow us to specify
an order to each factor "level" (each month is a level).

The syntax for this operation is 

1. turn field into a factor: `factor(fieldName) `
2. designate the `levels` using a list `c(level1, level2, level3)`

In our case, each level will be a month.


    #order the factors
    harMetDaily.09.11$month_name = factor(harMetDaily.09.11$month_name, 
                                          levels=c('January','February','March',
                                                   'April','May','June','July',
                                                   'August','September','October',
                                                   'November','December'))

Once we have specified the factor column and its associated levels, we can plot 
again. Remember, that because we have modified a column in our `data_frame`, we
need to rerun our `ggplot` code.


    #recreate plot
    airSoilTemp_Plot <- ggplot(harMetDaily.09.11, aes(airt, s10t)) +
               geom_point() +
               ggtitle("Air vs. Soil Temperature \n NEON Harvard Forest Field Site\n 2009-2011") +
                xlab("Air Temperature (C)") + ylab("Soil Temperature (C)") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    #create faceted panel
    airSoilTemp_Plot + facet_wrap(~month_name, nc=3)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-by-month-levels-1.png) 

##Subset by Season - *Advanced Topic*
Sometimes we want to group data by custom time periods. For example, we might
want to group by season. However, the definition of various seasons may vary by 
region which means we need to manually define each time period.

In the next section, we will add a season column to our data using a manually
defined query. Our field site is Harvard Forest (Massachusetts), located
in the northeastern portion of the United States. We can divide this 
region into 4 seasons as follows: 

 * Winter: December - February
 * Spring: March - May 
 * Summer: June - August
 * Fall: September - November 
 
In order to subset the data by season we will use the `dplyr` package.  We
can use the numeric month column that we added to our data earlier in this lesson.


    #add month to data_frame - note we already performed this step above.
    harMetDaily.09.11$month  <- month(harMetDaily.09.11$date)
    
    #view head and tail of column
    head(harMetDaily.09.11$month)

    ## [1] 1 1 1 1 1 1

    tail(harMetDaily.09.11$month)

    ## [1] 12 12 12 12 12 12

We can use `mutate()` and a set of `ifelse` statements to create a new
categorical variable called `season` by grouping three months together. 

Within `dplyr` `%in%` is short-hand for "contained within". So the syntax

`ifelse(month %in% c(12, 1, 2), "Winter",`

can be read as "if the `month` column value is 12 or 1 or 1, then assign the
value "Winter"". 

Our `ifelse` statement ends with

`ifelse(month %in% c(9, 10, 11), "Fall", "Error")`

which we can translate this as "if the `month` column value is 9 or 10 or 11,
then assign the value "Winter"."

The last portion `, "Error"` tells `R` that if a `month` column value does not 
fall within any of the criteria laid out in previous `ifelse` statements, to 
assign the column the value of "Error". 



    harMetDaily.09.11 <- harMetDaily.09.11 %>% 
      mutate(season = 
               ifelse(month %in% c(12, 1, 2), "Winter",
               ifelse(month %in% c(3, 4, 5), "Spring",
               ifelse(month %in% c(6, 7, 8), "Summer",
               ifelse(month %in% c(9, 10, 11), "Fall", "Error")))))
    
    
    #check to see if this worked
    head(harMetDaily.09.11$month)

    ## [1] 1 1 1 1 1 1

    head(harMetDaily.09.11$season)

    ## [1] "Winter" "Winter" "Winter" "Winter" "Winter" "Winter"

    tail(harMetDaily.09.11$month)

    ## [1] 12 12 12 12 12 12

    tail(harMetDaily.09.11$season)

    ## [1] "Winter" "Winter" "Winter" "Winter" "Winter" "Winter"

Now that we have a season column, we can plot our data by season!


    #recreate plot
    airSoilTemp_Plot <- ggplot(harMetDaily.09.11, aes(airt, s10t)) +
               geom_point() +
               ggtitle("Air vs. Soil Temperature\n 2009-2011\n NEON Harvard Forest Field Site") +
                xlab("Air Temperature (C)") + ylab("Soil Temperature (C)") +
               theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    
    #run this code to plot the same plot as before but with one plot per season
    airSoilTemp_Plot + facet_grid(. ~ season)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-by-season-1.png) 

Note, that once again, we re-ran our `ggplot` code to make sure our new column
is recognized by `R`. We can experiment with various facet layouts next.


    # for a landscape orientation of the plots we change the order of arguments in
        #facet_grid():
    airSoilTemp_Plot + facet_grid(season ~ .)

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-by-season2-1.png) 

<div id="challenge" markdown="1">

##Challenge: Create Plots by Season
The goal of this challenge is to create plots that show the relationship between
air and soil temperature across the different seasons.  
1. Create a *factor* season variable.  Convert the season column that we just
created to a factor, then organize the seasons chronologically as follows:
Winter, Spring, Summer, Fall. 

2. Create a new faceted plot that is 2 x 2 (2 columns of plots). One can neatly
plot multiple variables using facets as follows: 
`facet_grid(variable1 ~ variable2)`. 

3. Create a plot of air vs soil temperature grouped by year and season.
</div>

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/assigning-level-to-season-1.png) ![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/assigning-level-to-season-2.png) 

# zoo Package: Work with Year-Month Data
Some data sets will have a Year-Month date for their day data.  We may want to
summarize this data into a yearly total.  

To, convert a year-month field, with a base `R` date class, we would need to add
an associated day. The syntax would be:
`as.Date(paste(met_monthly_HARV$date,"-01", sep=""))`

The syntax above creates a `Date` column from the met_montly_HARV `date` column. 
We then add a arbitrary date, the first (`"-01"`).  The final bit of code
(`", sep="" "`) designates the character string used to separate the month, day,
and year portions of the returned string (nothing in our case).

Alternatively, we could use the `zoo` package which includes year-month
capabilities (`as.yearmon`). With `zoo` the syntax would be:
`as.Date(as.yearmon(met_monthly_HARV$date))`

<div id="challenge" markdown="1">
##Challenge: Plot with Year-Month Data

Create two faceted plots of annual air temperature for each year of data in the
file (2001-2015). Use the
`NEON-DS-Met-Time-Series/HARV/FisherTower-Met/hf001-04-monthly-m.csv` 
file. This contains monthly average data for the NEON Harvard Forest field site.

Create one plot using the methods for base `R` and create the second plot using
the methods with the `zoo` package.  

Experiment on your own to figure out the methods that you prefer!

</div>

![ ]({{ site.baseurl }}/images/rfigs/TS06-Plotting-Facets-And-Group-By-Time-In-R/plot-monthly-data-1.png) 

    ## Error: ggplot2 doesn't know how to deal with data of class Date

    ## Error in eval(expr, envir, enclos): object 'long_term_temp_zoo' not found
