---
layout: post
title: "Culmination Activity: Plot using Facets and Plot Time Series with NDVI Data"
date:   2015-10-16
authors: [Megan A. Jones, Leah A. Wasser]
contributors: []
dateCreated: 2015-10-22
lastModified: 2016-01-08
packagesLibraries: [ggplot2, scales, gridExtra, grid, dplyr, reshape2]
category:  
tags: [spatio-temporal, time-series, phenology]
mainTag: time-series
description: "This lesson is a data integration wrap-up culmination
activity for the ."
code1: TSCulmination-Work-With-NDVI-and-Met-Data-In-R.R
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: R/Work-With-NDVI-and-Met-Data-In-R
comments: false
---

{% include _toc.html %}

##About
This lesson is a culmination activity for the end of the lesson series on 
[tabular time series data in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series) 
and as part of a 
[spatio-temporal Data Carpentry workshop ]({{ site.baseurl }}self-paced-tutorials/spatio-temporal-workshop). 
The data used in this culmination activity has been extracted or previously
worked with in the 
[tabular time series data in R ]({{ site.baseurl }}self-paced-tutorials/tabular-time-series)
and  
[raster data in R ]({{ site.baseurl }}self-paced-tutorials/spatial-raster-series).

**R Skill Level:** Advanced/ Intermediate - you've got the basics of `R` down
 and are comfortable using `ggplot2` and `dplyr`. 

<div id="objectives" markdown="1">

#Goals / Objectives
After completing this activity, you will:

 * 

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

###Skills Needed
This lessons assumes familiarity with both the `dplyr` package and `ggplot()` in
the `ggplot2` package.  If you are not comfortable with either of these we
recommend starting with the 
[Subset & Manipulate Time Series Data with `dplyr` lesson]({{site.baseurl}}/R/Time-Series-Subset-dplyr/ "Learn dplyr") 
and the 
[Plotting Time Series with ggplot in R lesson]({{site.baseurl}}/R/Time-Series-Plot-ggplot/ "Learn ggplot")  
respectively, to gain familiarity.

</div>

##Plot NDVI & PAR using Daily Data

###NDVI Data
Normalized Difference Vegetation Index (NDVI) is an indicator of how green
vegetation is.  NDVI is derived from remote sensing data based on a ratio the
reluctance of visible red spectra and near-infrared spectra.  The NDVI values
vary from -1.0 to 1.0.  

The imagery data used to create this NDVI data were collected over the National
Ecological Observatory Network's
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank" >Harvard Forest</a>
field site.  
The imagery was created by the U.S. Geological Survey (USGS) using a 
<a href="http://eros.usgs.gov/#/Find_Data/Products_and_Data_Available/MSS" target="_blank" >  multispectral scanner</a>
on a
<a href="http://landsat.usgs.gov" target="_blank" > Landsat Satellite </a>.
The data files are Geographic Tagged Image-File Format (GeoTIFF).  
A tutorial, [Extract NDVI Summary Values from a Raster Time Series]({{ site.baseurl}}/R/Extract-NDVI-From-Rasters-In-R/), 
explains how to create this NDVI file from on Raster data. 

###Read In NDVI Data
We need to read in the 2011 NDVI data for the Harvard Forest. A .csv file is
within `HARV/NDVI` subdirectories in the `NEON-DS-Met-Time-Series` directory.

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
    
    #first read in the NDVI CSV data
    NDVI.2011 <- read.csv(
      file="NEON-DS-Met-Time-Series/HARV/NDVI/meanNDVI_HARV_2011.csv", 
      stringsAsFactors = FALSE
      )
    
    #check out the data
    str(NDVI.2011)

    ## 'data.frame':	11 obs. of  6 variables:
    ##  $ X        : int  1 2 3 4 5 6 7 8 9 10 ...
    ##  $ meanNDVI : num  0.365 0.243 0.251 0.599 0.879 ...
    ##  $ site     : chr  "HARV" "HARV" "HARV" "HARV" ...
    ##  $ year     : int  2011 2011 2011 2011 2011 2011 2011 2011 2011 2011 ...
    ##  $ julianDay: int  5 37 85 133 181 197 213 229 245 261 ...
    ##  $ Date     : chr  "2011-01-05" "2011-02-06" "2011-03-26" "2011-05-13" ...

    head(NDVI.2011)

    ##   X meanNDVI site year julianDay       Date
    ## 1 1 0.365150 HARV 2011         5 2011-01-05
    ## 2 2 0.242645 HARV 2011        37 2011-02-06
    ## 3 3 0.251390 HARV 2011        85 2011-03-26
    ## 4 4 0.599300 HARV 2011       133 2011-05-13
    ## 5 5 0.878725 HARV 2011       181 2011-06-30
    ## 6 6 0.893250 HARV 2011       197 2011-07-16

<div id="challenge" markdown="1">
##Challenge:  Convert Date in Character Class to a Date-Time Class
The `Date` data is currently in the character class, convert the data to a date
class. 
</div>



<div id="challenge" markdown="1">
##Challenge: Subset Only the 2011 Micrometeology Data
First lets get just 2011 from the `harmet.Daily` data since that is the only
year for which we have NDVI data.
</div>



In this dataset, we have the following variables:  

* 'X': an integer representing each row
* meanNDVI: the daily total NDVI for that area.  ("Mean" comes from the fact
   that the value is a mean of all pixels in the original raster).
* site: all NDVI values are from the Harvard Forest
* year: all values are from 2011
* julianDay: the numeric day of the year
* Date: a date in format "YYYY-MM-DD".

## Two y-axes or Side-by-Side Plots?
When we have different types of data like NDVI (scale: 0-1 index units) and PAR
(scale: 0-65.8 mole per meter squared) that we want to plot over time, we cannot
simply plot them on the same plot as they have different y-axes.  

One option, would be to plot both data types in the same plot space but each
having it's own axis.  However, there is a line of graphical representation 
thought that this is not a good practice.  The creator of `ggplot2` ascribes to
this dislike of different y-axes and so neither `qplot` nor `ggplot` have this
functionality.  

Instead, plots of different types of data can be plotted next to each other to 
allow for comparison.  Depending on how the plots are being viewed they can have
a vertical or horizontal arrangement.  

Following this second option, we will create a plot for each variable using the
same time variable (Julian day) as our x-axis.

Then we will plot the two plots in the same viewer so we can more easily compare
them.  


    #create plot of julian day vs. PAR
    plot.par.2011 <- ggplot(harMet.daily2011, aes(date, part))+
      geom_point(na.rm=TRUE) +
      ggtitle("Daily PAR at Harvard Forest, 2011")+
      theme(legend.position = "none",
            plot.title = element_text(lineheight=.8, face="bold",size = 20),
            text = element_text(size=20))
    
    plot.NDVI.2011 <- ggplot(NDVI.2011, aes(Date, meanNDVI))+
      geom_point(colour = "forestgreen", size = 4) +
      ggtitle("Daily NDVI at Harvard Forest, 2011")+
      theme(legend.position = "none",
            plot.title = element_text(lineheight=.8, face="bold",size = 20),
            text = element_text(size=20))
     
    #display the plots together
    grid.arrange(plot.par.2011, plot.NDVI.2011) 

![ ]({{ site.baseurl }}/images/rfigs/TSCulmination-Work-With-NDVI-and-Met-Data-In-R/plot-PAR-NDVI-1.png) 

This is nice but a bit confusing as the time on our x-axis doesn't fully line
up.  To fix this we can assign the same min and max to both x-axes so that they
align.  We can also label the axes. 


    plot2.par.2011 <- plot.par.2011 +
      scale_x_date(labels = date_format("%b %d"),
                   breaks = "3 months", minor_breaks= "1 week",
                   limits=c(min=min(NDVI.2011$Date),max=max(NDVI.2011$Date)))+
      ylab("Total PAR") + xlab ("")
     
    
    plot2.NDVI.2011 <- plot.NDVI.2011 +
      scale_x_date(labels = date_format("%b %d"),
                   breaks = "3 months", minor_breaks= "1 week",
                   limits=c(min=min(NDVI.2011$Date),max=max(NDVI.2011$Date)))+
      ylab("Total NDVI") + xlab ("Date")
    
    grid.arrange(plot2.par.2011, plot2.NDVI.2011) 

    ## Error in strsplit(unitspec, " "): non-character argument

<div id="challenge" markdown="1">
##Challenge: Plot Air Temperature and NDVI
Create a complementary plot pairing with Air Temperature and NDVI.  Choose 
colors and symbols that show the data well.  Finally, plot air temperature, PAR,
and NDVI in a single window to ease comparisons.  
</div>


    ## Error in strsplit(unitspec, " "): non-character argument

    ## Error in strsplit(unitspec, " "): non-character argument

##Two plots with One x-axis.  
We are able to nicely see the three different variables.  However, we waste a
lot of space to repeating the x-axes and the titles.  Instead of three separate
plots we could alternatively, use facets and plot all the variables of interests
(NDVI, air temperature, precipitation, and PAR) on a single x-axis.  To do this
we'll use `melt()` from the `reshape2` package. `melt` transforms the data from
a wide format (columns of different variables with values in them), to a long
format (column of variables with a column of values) organized according to a
specified variable.  


    library(reshape2)  #allows us to "melt" dataframes from "wide" to "long"
    
    #merge the two data frames by date and retain all 'harMet.daily
    harMetNDVIall.daily.2011<- merge(harMet.daily2011, 
                                     NDVI.2011, by.x = "date", 
                                     by.y = "Date", all.x=TRUE)
    
    #convert from "wide" form to "long" form
    harMetNDVI.daily.2011.long<-melt(harMetNDVIall.daily.2011, id ="date")

    ## Warning: attributes are not identical across measure variables; they will
    ## be dropped

Once we have the data in the long form we can subset and then plot the data. 


    #subset to retain just the variables of interest.  The vertical bar character
    # means "OR".
    harMetNDVI.daily.2011.select<-subset(harMetNDVI.daily.2011.long,
                                    variable=="meanNDVI"| variable== "prec"|
                                    variable == "airt" | variable == "part")
    
    NDVI.harMet.facet.plot<-ggplot(
      harMetNDVI.daily.2011.select,
      aes(date, value), group=variable) +
      geom_point() +
      facet_grid(variable~., scales="free") +   #specify facets & y-axis can vary
      ggtitle("Harvard Forest 2011") +
      scale_x_date(labels = date_format("%b %d"),  #abbreviated month & day
                   breaks = "3 months", minor_breaks= "1 month") +  #where grid is
      xlab ("Date") + ylab ("Value") +
      theme(legend.position = "none",
            plot.title = element_text(lineheight=.8, face="bold",size = 20),
            text = element_text(size=10)
      ) 
    
    NDVI.harMet.facet.plot

    ## Error in strsplit(unitspec, " "): non-character argument

![ ]({{ site.baseurl }}/images/rfigs/TSCulmination-Work-With-NDVI-and-Met-Data-In-R/plot-same-x-axis-2-1.png) 
