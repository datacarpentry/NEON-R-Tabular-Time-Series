---
layout: tutorial
title: "Self-paced Tutorial: Working with Tabular Time Series"
estimatedTime: 3.0 Hours
packagesLibraries: [ggplot2, scales, gridExtra, grid, zoo, dplyr, lubridate, ggthemes, reshape2]
date:   2015-1-15 20:49:52
dateCreated:   2015-10-15 17:00:00
lastModified: 2015-01-05 13:00:00
authors: [Megan A. Jones, Leah A. Wasser, Marisa Guarinello, Courtney Soderberg]
categories: [self-paced-tutorial]
tags: []
mainTag: time-series
description: "This self-paced tutorial explain how to work with tabular (.csv) 
time series data in R.  The data set used consists of micro-meteorology data 
collected at the NEON Harvard Forest field site and focuses on understanding 
annual patterns and phenology, however, the data skills cover are applicable to
all types of tabular data.  The tutorial consists of six sequential lessons, an
auxiliary lesson, and a culminating activity." 
code1: 
workshopName: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: tutorial/tabular-time-series
comments: false
---

This self-paced tutorial explain how to work with tabular (.csv) 
time series data in R.  The data set used consists of micro-meteorology data 
collected at the NEON Harvard Forest field site and focuses on understanding 
annual patterns and phenology, however, the data skills cover are applicable to
all types of tabular data.  The tutorial consists of six sequential lessons, an
auxiliary lesson, and a culminating activity. 


<div id="objectives" markdown="1">

#Goals / Objectives
After completing this lesson, you will:

 * OVERALL GOALS or list for each lesson? 


##Things You’ll Need To Complete This Lesson

###Setup RStudio
To complete the tutorial series you will need an updated version of R and,
 preferably, RStudio installed on your computer.
 <a href = "http://cran.r-project.org/">R</a> is a programming language
 that specializes in statistical computing. It is a powerful tool for
 exploratory data analysis. To interact with R, we strongly recommend 
<a href="http://www.rstudio.com/">RStudio</a>, an interactive development 
environment (IDE). 


###Install R Packages
You can chose to install packages with each lesson or you can download all 
of the necessary R Packages now. 

* **ggplot2:** `install.packages("ggplot2")`
* **ggthemes:** `install.packages("ggthemes")`
* **scales:** `install.packages("scales")`
* **gridExtra:** `install.packages("gridExtra")`
* **grid:** `install.packages("grid")`
* **reshape2:** `install.packages("reshape2")`
* **dplyr:** `install.packages("dplyr")`

[More on Packages in R - Adapted from Software Carpentry.]({{site.baseurl}}R/Packages-In-R/)

<\div>


