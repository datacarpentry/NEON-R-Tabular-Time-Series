---
layout: post
title: "Lesson 04 Data Exploration"
date:   2015-10-24
authors: "Marisa Guarinello, Megan Jones, Courtney Soderberg"
dateCreated: 2015-10-22
lastModified: 2015-10-29
tags: [module-1]
description: "This lesson will teach individuals how to plot subsetted timeseries
data (e.g. plot by season) and to plot time series data with NDVI."
code1:
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: 

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
This activity will walk you through the fundamental principles of working 
with raster data in R.

**R Skill Level:** Intermediate - you've got the basics of `R` down.

<div id="objectives">

<h3>Goals / Objectives</h3>
After completing this activity, you will know:
<ol>
<li>How to use facets in ggplot</li>
<li>How to combine different types of data into one plot.</li>
</ol>

<h3>Things You'll Need To Complete This Lesson</h3>

<h3>R Libraries to Install:</h3>
<ul>
<li><strong>raster:</strong> <code> install.packages("ggplot2")</code></li>

</ul>
<h4>Tools To Install</h4>

Please be sure you have the most current version of `R` and preferably
R studio to write your code.

#Graph precip by total PAR across all seasons

    part.prec <- ggplot(harMet.daily,aes(prec, part)) +
               geom_point() +
               ggtitle("Relationship between precipitation and PART") +
               theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
               theme(text = element_text(size=20)) +
               xlab("Total Precipitation") + ylab("Mean Total PAR")

    ## Error in ggplot(harMet.daily, aes(prec, part)): object 'harMet.daily' not found

#Use daily data and subset by seasons (retaining PAR, prec, & temp variables)

    #subset by season using month (12-2 is winter, 3-5 spring, 6-8 summer, 9-11 fall)

#Use facets in ggplot to create the same graph for each season and display them in a grid

    #part.prec + facet_grid(. ~ season)
    #part.prec + facet_grid(season ~ .)
    
    #part.prect + facet_wrap(~season, ncol = 2)

#Graph one of those variables and NDVI data together
