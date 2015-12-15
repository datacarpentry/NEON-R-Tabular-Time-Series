---
layout: post
title: "Lesson 05: Plotting Time Series with ggplot in R"
date:   2015-10-20
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
contributors: [Leah A. Wasser, Michael Patterson]
dateCreated: 2015-10-22
lastModified: 2015-12-14
tags: [module-1]
packagesLibraries: [lubridate, ggplot2, scales, gridExtra, dplyr]
category: 
description: "This lesson teaches how to create plots of time series data using `ggplot()`."
code1: TS05-Plotting-Time-Series-ggplot-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: /R/Time-Series-Plot-ggplot
comments: false
---

{% include _toc.html %}


##About
This lesson teaches how to create plots of time series data using `ggplot()`.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives" markdown="1">

### Goals / Objectives
After completing this lesson, you will:
 * Be able to create basic time series plots using `ggplot()` in `R`.
 * Understand the synthax of `ggplot()` and know how to find out more about the
 package. 
 * Be able to choose between visually representing data as points or bars in a
 plot.
 
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
<li><strong>scales:</strong> <code> install.packages("scales")</code></li>
<li><strong>gridExtra:</strong> <code> install.packages("gridExtra")</code></li>

  <a href="http://neondataskills.org/R/Packages-In-R/" target="_blank">
More on Packages in R - Adapted from Software Carpentry.</a>

####Data to Download
<a href="https://ndownloader.figshare.com/files/3579861" class="btn btn-success"> Download Atmospheric Data</a>

The data used in this lesson were collected at Harvard Forest which is
an National Ecological Observatory Network  
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank"> field site</a>. 
These data are proxy data for what will be available for 30 years
on the [NEON data portal](http://data.neoninc.org/ "NEON data")
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

#Plotting Time Series Data
Visualization of data is important as it allow us to get a sense of 
general trends, see possible outliers or non-sensical values and, eventually, to
create publishable figures to support our research. 

The final products of this lesson will be two different plots ready for putting
in a presentation or publishing in a paper. 

##ggplot2
If, after this lesson, you would like more information on creating graphics in
`R` using `ggplot2` consider: 

 * visting Winston Chang's <a href="http://www.cookbook-r.com/Graphs/index.html" target="_blank"> Cookbook for R</a> site based on his R Graphics Cookbook text. 
 * going through the NEON #WorkWithData lesson on <a href="http://neondataskills.org/R/Plotly/" target="_blank"> 
Interactive Data Viz Using R, GGPLOT2 and PLOTLY</a>.
 * going through Data Carpentry's <a href="http://www.datacarpentry.org/R-ecology/05-visualisation-ggplot2.html" target="_blank"> 
Data Visualization with ggplot2 lesson</a> Data Visualization with ggplot2 lesson.
 * reading Hadley Wickham's <a href="http://docs.ggplot2.org/" target="_blank"> 
documentation</a> on the `ggplot2` package. 

###Load the Data
You will need the daily micro-meteorology data for 2009-2011 from
the Harvard Forest. If you do not already have these data sets as `R` objects, 
please load them from the .csv files in the downloaded data.  


    #Remember it is good coding technique to add additional libraries to the top of
      #your script 
    library(lubridate) #for working with dates
    library(ggplot2)  #for creating graphs
    library(scales)   #to access breaks/formatting functions
    library(gridExtra) #for arranging plots
    
    #set working directory to ensure R can find the file we wish to import
    #setwd("working-dir-path-here")
    
    #daily HARV met data, 2009-2011
    harMetDaily.09.11 <- read.csv(file="AtmosData/HARV/Met_HARV_Daily_2009_2011.csv",
                         stringsAsFactors = FALSE)
    
    #covert date to POSIXct date-time class
    harMetDaily.09.11$date <- as.POSIXct(harMetDaily.09.11$date)
    
    #monthly HARV temperature data, 2009-2011
    harTemp.monthly.09.11<-read.csv(file=
                            "AtmosData/HARV/Temp_HARV_Monthly_09_11.csv",
                            stringsAsFactors=FALSE)
    #convert datetime from chr to datetime class & rename date for clarification
    harTemp.monthly.09.11$date <- as.POSIXct(harTemp.monthly.09.11$datetime)


##Plot with qplot
Using the library `ggplot2` we can use the simple `qplot()` function make a
quick plot of the air temperature (`airt`) across all three years using the
daily data. 


    qplot (x=date, y=airt,
          data= harMetDaily.09.11,
          main= "Air temperature Harvard Forest\n 2009-2011",
          xlab= "Date", ylab= "Temperature (°C)")

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/qplot-1.png) 

When we do this we get a warning message reminding us that there are two missing
values in the 
air temperature data and a plot showing the pattern of air temperature across
the three years.

##Plot with ggplot
While `qplot()` is a simple way to quickly plot data, it is limited in it's ability
to be modified and customized into professional looking plots.  The `ggplot()` 
function within `ggplot2` package allows the user to have much more control
over the appearance of the plot.  

Let's plot the same data again using `ggplot()`.  While `ggplot()` is based on 
using much of the information we just used with `qplot`, the syntax is 
different.  Three basic elements are needed:

 1. the data,
 2. `aes` aesthetics: which denotes which variables will map to the x-, y- (and 
other) axes,  
 3. `geom_XXX` (geometry) which defines the type of graphical representaiton
you want for the data.  We want a scatterplot so we are using ``geom_point`. 

To customize the plot we can then add other specifications within the attributes
of one of these elements. For example, if we want the NA values to be ignored, 
we include `na.rm=TRUE` within the `geom_point()` function.  

Alternatively, specifications that apply to the overall figure are simply added
within the `ggplot()` function by adding them, with `+`, after the preceding
argument.  For example, we can add a title by using `+ ggtitle="XXX",` or axis
labels using `+ xlab("XXX") + ylab("XXX")`.  

Remember `help(ggplot2)` will list the many other parameters that can be 
defined. There are far more ways `ggplot2` can be used to create and customize 
plots, but we will not cover those additional details in this lesson to
keep the focus on working with time series data.


    #plot Air Temperature Data across 2009-2011 using 15-minute data
    AirTempDailya <- ggplot(harMetDaily.09.11, aes(date, airt)) +
               geom_point(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                          # that 2 NA values were removed.
               ggtitle("Air Temperature Harvard Forest\n 2009-2011") +
               xlab("Date") + ylab("Air Temperature (C)")
    AirTempDailya

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/basic-ggplot2-1.png) 

Notice we created an object (AirTempDailya) that is our plot.  We then have to
write in the object name to get the plot to appear.  Creating plots as an 
`R` object has many advantages including being able to simply add to a plot, as
we will do in just a few lines, and to be able to recall a plot later on in code,
as we do at the end of this lesson. 

##Formatting Dates in Axis Labels
The dates on the x-axis in this last plot are not particularly
well formatted. We can reformat them so they are in the Month Year format by 
simply adding onto the `AirTemp15a` plot that we just created. 

    #format x-axis: dates
    AirTempDailyb <- AirTempDailya + (scale_x_datetime(labels=date_format("%b %y")))
    AirTempDailyb

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/nice-x-axis-1.png) 

The dates are now legible on the x-axis. Notice in the code for the x scale
(`scale_x_datetime()`), we changed the date format from %m to %b which gives the
abreviated month.

Bonus: If an x variable is not a datetime class (e.g., not POSIX),
`scale_x_...()` exist to help format x-axes. {.notice2}

##Use Theme() to Customize ggplot Figures
The ability to customize nearly every aspect of the plot is one of the reasons
to use `ggplot2`. The `theme()` function is a very useful tool for changing the
appearance of all of the non-data elements of a figure.  We are only going to 
customize the text in this section.  You can find the other arguments for 
`theme()` at Hadley Wickham's <a href="http://docs.ggplot2.org/0.9.2.1/theme.html" target="_blank"> 
documentation</a> `theme()` documentation. 


    #format x axis with dates
    AirTempDaily<-AirTempDailyb +
      #theme(plot.title) allows to format the Title seperately from other text
      theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
      #theme(text) will format all text that isn't specifically formatted elsewhere
      theme(text = element_text(size=18)) 
    AirTempDaily

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/nice-font-1.png) 


#Challenge: Plotting Daily Precipitaiton Data
Use the `harMetDaily.09.11` data to create a plot of percipitation.  
Format the date to appear as Day-Month-Year.  For ease in future activities 
name the plot 'PrecipDaily".

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/challenge-code-ggplot-precip-1.png) 

##Figures with Bars
In the previous figure we get a scatterplot of precipitation by date, however, 
the precipitation is a daily cumulative figure so it makes more sense to
represent the data as bars not points.  We can easily do this by changing the
code from `geom_point` to `geom_bar`.  This changes the figure from a scatter
plot to a bar chart.  

The default for `geom_bar()` is stat="bin", perfect for making
histograms.  However, we don't want a histogram, we want the bars to be for the
varible (precipiation) mapped to the y-axis.  Therefore we must specify  
`geom_bar(stat="identity")`. 


    PrecipDailyBarA <- ggplot(harMetDaily.09.11, aes(date, prec)) +
               geom_bar(stat="identity") +
               ggtitle("Daily Precipitation\n Harvard Forest") +
                xlab("Date") + ylab("Precipitation (mm)") +
                scale_x_datetime(labels=date_format ("%b-%y")) +
                theme(plot.title = element_text(lineheight=.8, face="bold",
                     size = 20)) +
               theme(text = element_text(size=18))
    PrecipDailyBarA

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/ggplot-geom_bar-1.png) 

Why do some of the bars appear black and some appear grey?  Zoom in on the 
figure, now we can see all the bars are black.  When there is lots of data 
overlapping RStudio will fade the color of some of the objects to increase 
readability.  

##Color
We can change the color of points or bar by specifying the color within the
`geom_XXX()` attributes using `colour=` or, if we prefer seperate fill and line
colors, `fill=` and `line=`.  Colors can be specified by a common name (for
simple colors) or hexidecimal color codes (e.g, #FF9999).  


    #specifying color by name
    PrecipDailyBarB <- PrecipDailyBarA+
      geom_bar(stat="identity", colour="darkblue")
    
    PrecipDailyBarB

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/ggplot-color-1.png) 

    #specifying color by hexidecimal code
    AirTempDaily+geom_point(colour="#66ffb3", na.rm=TRUE)

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/ggplot-color-2.png) 

Notice that color choice is important in figures. #66ffb3 is probably not a 
great choice for this plot.

For more information on color, including color blind friendly color palletes, 
read the  <a href="http://www.cookbook-r.com/Graphs/Colors_(ggplot2)/" target="_blank">
ggplot2 color information</a> from Winston Chang's *Cookbook* *for* *R* site 
based on the _R_ _Graphics_ _Cookbook_ text. 

##Figures with Lines
Often when plotting data from a time series, representing the data with a line 
makes sense.  Let's try it with our daily air temperature data. 

    AirTempDailyline <- ggplot(harMetDaily.09.11, aes(date, airt)) +
               geom_line(na.rm=TRUE) +    #na.rm=TRUE prevents a warning stating
                                          # that 2 NA values were removed.
               ggtitle("Air Temperature Harvard Forest\n 2009-2011") +
               xlab("Date") + ylab("Air Temperature (C)") +
              theme(plot.title = element_text(lineheight=.8, face="bold", 
                                              size = 20)) +
               theme(text = element_text(size=18))
    AirTempDailyline

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/ggplot-geom_lines-1.png) 

This might be worse than having the individual points.  When might lines be
better than points?   

###Challenge: Combine Points & Lines
What happens if you simply add the `geom_line()` to the original `AirTempDaily` 
plot instead of substituting `geom_line()` for `geom_points()` like we just did?

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/challenge-code-geom_lines&points-1.png) 

Interesting, but not the best representation of this data.  Perhaps what would
be better is a scatter plot of the data points with a trend line over it. 


##Add a Trend Line

Remember a trend line is a statistical transformation of the data, so prior to
adding the line one must understand if a particular statistical transformation
is correct for the data at hand.  {: .notice1} 

Trend lines can be added with the `stat_smooth()` function.  Within the function
we must specify which method we'd like to use for the statistical
transformation. There are numerous methods that can be specified including
linear regression (method="lm"). The default is loess (a non-parametric 
regression model; for data sets <1000 observations) or gam (a general additive 
model; if >1000 observations). 

Our air temperature data, three years of a well defined annual cycle, should be 
appropriate for either
the non-parametric loess or gam model methods.  How large is our data set?
Which method will be used by default?  


    #adding on a trend lin using loess
    AirTempDailyTrend <- AirTempDaily + stat_smooth(colour="green")
    AirTempDailyTrend

    ## geom_smooth: method="auto" and size of largest group is >=1000, so using gam with formula: y ~ s(x, bs = "cs"). Use 'method = x' to change the smoothing method.

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/ggplot-trend-line-1.png) 

As our data set has 1095 observations the default gam method was used with a 
specified 
formula.  An algarithm in this package determined the formula for this
line, if we had figured out a different GAM model for the air temperature data
we could have input our own model parameters.   

#Challenge: A Trend in Percipitation? 
Create a figure showing a linear trend for the daily percipitation model.  Make
the precipitation data as purple bars (added challenge: find hexicolor code and 
make bars the color "dark orchid 4") with a grey trend line. Format the dates to
appear as Jan 2009 and make the title in an italic font.

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/challenge-code-linear-trend-1.png) 


#Challenge: Plot Monthly Air Temperature

Use the `harTemp.monthly.09.11` data frame to plot the monthly air temperature
throughout the three years of interest (2009-2010).  For ease of future code,
name your plot "AirTempMonthly".

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/plot-airtemp-Monthly-1.png) 

##Displaying Multiple Figures in Same Panel
How does our new plot (`AirTemp Monthly`) compare to our previous air 
temperature plot (`AirTempDaily`)? 

To ease our comparison we can tell `R` to display both figures at the same time.
With base `R` you might be familiar with using `par(mfrow=())` to set this.  
However, this will not work with `ggplot2` functions.  Instead we will use the 
`grid.arrange()` function from the `gridExtra` package to display multiple 
figures simultaneously.  



    grid.arrange(AirTempDaily, AirTempMonthly, ncol=1)

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/compare-precip-1.png) 

On which plot is it easier to see annual patterns of air temperature?  Can you
think of when you might use one plot or another?  Remember if the plots are too
small you can use the zoom feature in R Studio to pop the out into a seperate
window. 

#Challenge: Arrangement of Multiple Figures
Rearrange the same two plots so that they are side by side instead of stacked 
one on top of the other.  

![ ]({{ site.baseurl }}/images/rfigs/TS05-Plotting-Time-Series-ggplot-In-R/challenge-code-grid-arrange-1.png) 

#Polish ggplot Figures
Throughout this module we have been creating plots using ggplot.  We've covered
the basics of adding axis labels and titles but using ggplot you can do so much 
more.  If you are interested in making your graphs look better consider
following up with any of these resources:

1) ggplot2 Cheatsheet from Zev Ross: <a href="http://neondataskills.org/cheatsheets/R-GGPLOT2/" target="_blank"> ggplot2 Cheatsheet</a>  
2) ggplot2 documentation index: 
 <a href="http://docs.ggplot2.org/current/index.html#" target="_blank"> ggplot2 Documentation</a>    
3) NEON's Publishable Maps Tutorial  (Currently in draft, link will be updated
when published)