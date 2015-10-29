---
layout: post
title: "More advanced data exploration"
date:   2015-1-26 20:49:52
authors: "Courtney Soderberg"
dateCreated:  2014-11-26 20:49:52
lastModified: 2015-07-23 14:28:52
category: time-series-workshop
tags: [module-1]
mainTag: GIS-Spatial-Data
description: "This post explains the fundamental principles, functions and metadata that you need to work with raster data in R."
code1: 
image:
  feature: lidar_GrandMesa.png
  credit: LiDAR data collected over Grand Mesa, Colorado - National Ecological Observatory Network (NEON)
  creditlink: http://www.neoninc.org
permalink: /R/Raster-Data-In-R/
code1: /R/2015-07-22-Introduction-to-Raster-Data-In-R.R
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

    ## Error in eval(expr, envir, enclos): could not find function "ggplot"

#Use daily data and subset by seasons (retaining PAR, prec, & temp variables)




