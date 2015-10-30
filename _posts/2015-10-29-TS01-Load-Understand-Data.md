---
layout: post
title: "Lesson 01: Load and Understand Your Data"
date:   2015-10-21
authors: "Marisa Guarinello, Megan Jones, Courtney Soderberg"
dateCreated:  2015-10-22
lastModified: 2015-10-29
tags: [module-1]
description: "This lesson will teach individuals how to import tabular data from
a CSV file into R. Students will examine the structure of the dataset and get 
information from a related metadata text file."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
permalink: m
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


    # output will have width of 80 max
    options(width=80)

##About
This lesson will teach students how to import tabular data from a CSV file into
R. Students will examine the structure of the dataset and get information from a
related metadata text file.

**R Skill Level:** Intermediate - you've got the basics of `R` down and 
understand the general structure of tabular data.

###Goals / Objectives
After completing this lesson, you will know how to:

*Open a csv file in R and why we are using that format in this training
*Examine data structures and types
*Use metadata to get more information about input data


###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of R and preferably
R studio to write your code.

####R Libraries to Install
No additional libraries are needed for this lesson

####Data to Download

Make sure you have downloaded the AtmosData folder from
http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068


####Recommended Pre-Lesson Reading
None

## Lesson One: Load and Understand Your Data
We don't need any additional packages for this lesson, but typically when you 
initiate a workflow you always want to load any packages prior to importing and
working with your data. If you need another package later, you will also add it
here. It is also good practice to include a short note in your code comments 
that gives each library's purpose in your script. This will help you later when
you write new scripts for other projects.

You should then set your working directory to  where ever you have just
downloaded the data files.


    # Load packages required for entire script
    #library(nameOfLibrary)  #purpose of library
    
    #set working directory
    setwd("~/Documents/FILES/Learning/R/NEON_wrkshp")

    ## Error in setwd("~/Documents/FILES/Learning/R/NEON_wrkshp"): cannot change working directory

You are now ready to import the data.  This data is a csv or comma seperated
value file.  This file format is an excellent way to store tabular data in a
plain text format that can be read by many different programs including R.  

    # Load csv file of 15 min meterological data from Harvard Forest
    # don't load strings (a series of letters or numerals) as factors so they remain
    #characters
    harMet15 <- read.csv(file="data/AtmosData/HARV/hf001-10-15min-m.csv",
          stringsAsFactors = FALSE)

    ## Warning in file(file, "rt"): cannot open file 'data/AtmosData/HARV/
    ## hf001-10-15min-m.csv': No such file or directory

    ## Error in file(file, "rt"): cannot open the connection

# Data Structure & Metadata
Now it is time to look at our data and information about how R 'sees' our data.
There are three options for how we can look at our data, in the console using 
head() or by opening the object using View(), or clicking on the object in the 
Environment pane of RStudio. Once we open the data, we will look at the 
structure of the data as interpreted by R.


    #to see first few lines of data file
    head(harMet15)

    ## Error in head(harMet15): object 'harMet15' not found

    #if you want to see it in spreadsheet form and scroll
    View(harMet15)

    ## Error in View : object 'harMet15' not found

    #Check how R is seeing my data. What is the structure (str) of the data? 
    #Is it what I expect to see?  
    str(harMet15)

    ## Error in str(harMet15): object 'harMet15' not found

These commands let you see the data and get some information about it, but there
is other information we need to know. Can you think of any examples? 

To get some of this information, or clues to this information, we will open the
metadata text file that is in the AtmosData folder. Navigate to this file and 
open it in your text editor of choice.

Remember for this module we will be looking at air temperature, precipitation, 
and photosynthetically active radiation or PAR. Find these variables and 
identifywhat information the metadata tells you about these variables. We will
show what
we think is important from this metadata to our analysis here as comments. These
can be helpful if we share the R file with others or with your future self. Make
notes that are intuitive and make sense to you but that others can read and 
understand as well.


    # column names for variables we are going to use (when different the two
    # files--15min/daily): datetime/date, airt, prec, parr/part 
    # units for quantitative variables: celsius, millimeters, molePerMeterSquared
    # airt and parr are averages of measurements taken every 1 sec; precip is total 
    # of 15 min period for quantitative variables missing values are given as NA

# Metadata Sleuthing
Questions: Is there information provided here that doesn't match what you see in
the data? Is there information you want to know that is not provided in this 
metadata file? Do you have ideas for how you might find that information?

Again, it is a good practice to make relevant notes from the metadata in your R
script so that you can easily refer to it as you actually work with the data.

Answer: No information is given for date besides that it is a date. It would be 
nice to know if it was recorded in UTC/GMT, or local time. Hopefully you noticed
that there is a link to the website at the top. Check it out to see if you can 
get the answer to your question.

The website gives more information that we have in our metadata file. And it 
gives us important information about date- all are in Eastern Standard Time.

Again, it is a good practice to make relevant notes from the metadata in your R 
script so that you can easily refer to it as you actually work with the data.


    # website for more information: http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
    # date-times are in Eastern Standard Time
    # preview tab give plots of all variables

Bonus: Do you see anything else that might be related to metadata? EML file. 
This is the official standards based metadata file using the Ecological Metadata
Language (EML). Download this to your data folder. EML seems like an odd choice
but seeing this is an LTER site it makes sense because LTER uses EML extensively
in their projects.


    # EML file in the data folder now - all metadata information in there.

Now we have important information that will help us as we continue to use these
data for time series analysis.
