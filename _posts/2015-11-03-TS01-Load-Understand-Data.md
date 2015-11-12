---
layout: post
title: "Lesson 01: Load and Understand Your Data"
date:   2015-10-24
authors: [Megan A. Jones, Marisa Guarinello, Courtney Soderberg]
dateCreated:  2015-10-22
lastModified: 2015-11-12
tags: [module-1]
description: "This lesson will teach individuals how to import tabular data from a CSV file into R. Students will examine the structure of the dataset and get information from a related metadata text file."
code1: 
image:
  feature: NEONCarpentryHeader_2.png
  credit: A collaboration between the National Ecological Observatory Network (NEON) and Data Carpentry
  creditlink: http://www.neoninc.org
comments: false
---

{% include _toc.html %}


##About
This lesson will teach students how to import tabular data from a CSV file into
R. Students will examine the structure of the dataset and get information from a
related metadata text file.

<div id="objectives" markdown="1">

**R Skill Level:** Intermediate - you've got the basics of `R` down and 
understand the general structure of tabular data.

###Goals / Objectives
After completing this lesson, you will know how to:

 * Open a csv file in R and understand why we are using that format
 * Examine data structures and types
 * Use metadata to get more information about input data


###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of R and preferably
R studio to write your code.

####R Libraries to Install
No additional libraries are needed for this lesson

####Recommended Pre-Lesson Reading
Lessons 00 in this Time Series learning module

####Data to Download
Make sure you have downloaded the AtmosData folder from
http://figshare.com/articles/NEON_Spatio_Temporal_Teaching_Dataset/1580068

</div>

NOTE: The data used in this tutorial were collected at Harvard Forest which is
a the National Ecological Observatory Network field site <a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank">
More about the NEON Harvard Forest field site</a>. These data are proxy data for what will be
available for 30 years from the NEON flux tower [from the NEON data portal](http://data.neoninc.org/ "NEON data").
{: .notice}


#Lesson One: Load and Understand Your Data
We don't need any additional packages for this lesson, but typically when you 
initiate a workflow you always want to load any packages prior to importing and
working with your data. If you need another package later, you will also add it
here. It is also good practice to include a short note in your code comments 
that gives each library's purpose in your script. This will help you later when
you write new scripts for other projects.

You should then set your working directory to the location where you
downloaded the data files.


    # Load packages required for entire script
    # library(nameOfLibrary)  #purpose of library
    
    #set working directory
    setwd("~/Documents/data/Spatio_TemporalWorkshop/1_WorkshopData")

You are now ready to import the data.  This data is a CSV or comma-seperated
value file.  This file format is an excellent way to store tabular data in a
plain text format that can be read by many different programs including R.  

    # Load csv file of 15 min meterological data from Harvard Forest
    #don't load strings (a series of letters or numerals) as factors so they remain characters
    harMet15 <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
          stringsAsFactors = FALSE)

# Data Structure & Metadata
Now it is time to look at our data and information about how R 'sees' it.
There are three options for how we can look at our data, in the console using 
head() or by opening the object using View(), or clicking on the object in the 
Environment pane of RStudio. Once we open the data, we will look at the 
structure of the data as interpreted by R.


    #to see first few lines of data file
    head(harMet15)

    ##           datetime jd airt f.airt rh f.rh dewp f.dewp prec f.prec slrr
    ## 1 2005-01-01T00:15  1  5.1        84       2.5           0           0
    ## 2 2005-01-01T00:30  1  5.0        84       2.5           0           0
    ## 3 2005-01-01T00:45  1  4.9        85       2.6           0           0
    ## 4 2005-01-01T01:00  1  4.7        86       2.6           0           0
    ## 5 2005-01-01T01:15  1  4.5        87       2.6           0           0
    ## 6 2005-01-01T01:30  1  4.6        87       2.7           0           0
    ##   f.slrr parr f.parr netr f.netr  bar f.bar wspd f.wspd wres f.wres wdir
    ## 1           0         -58        1017        2.6         2.4         205
    ## 2           0         -59        1017        2.3         2.1         213
    ## 3           0         -59        1017        2.1         1.8         217
    ## 4           0         -58        1017        1.8         1.6         226
    ## 5           0         -58        1017        1.4         1.2         224
    ## 6           0         -58        1017        1.6         1.4         214
    ##   f.wdir wdev f.wdev gspd f.gspd s10t f.s10t
    ## 1          26         7.2         0.7       
    ## 2          25         5.9         0.7       
    ## 3          27         5.8         0.7       
    ## 4          26         5.1         0.7       
    ## 5          29         4.6         0.7       
    ## 6          30         4.4         0.7

    #to see it in spreadsheet form and scroll
    View(harMet15)
    
    #Check how R is seeing my data. What is the structure (str) of the data? 
    #Is it what I expect to see?  
    str(harMet15)

    ## 'data.frame':	376800 obs. of  30 variables:
    ##  $ datetime: chr  "2005-01-01T00:15" "2005-01-01T00:30" "2005-01-01T00:45" "2005-01-01T01:00" ...
    ##  $ jd      : int  1 1 1 1 1 1 1 1 1 1 ...
    ##  $ airt    : num  5.1 5 4.9 4.7 4.5 4.6 4.6 4.7 4.6 4.6 ...
    ##  $ f.airt  : chr  "" "" "" "" ...
    ##  $ rh      : int  84 84 85 86 87 87 87 88 88 88 ...
    ##  $ f.rh    : chr  "" "" "" "" ...
    ##  $ dewp    : num  2.5 2.5 2.6 2.6 2.6 2.7 2.7 2.8 2.8 2.8 ...
    ##  $ f.dewp  : chr  "" "" "" "" ...
    ##  $ prec    : num  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.prec  : chr  "" "" "" "" ...
    ##  $ slrr    : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.slrr  : chr  "" "" "" "" ...
    ##  $ parr    : int  0 0 0 0 0 0 0 0 0 0 ...
    ##  $ f.parr  : chr  "" "" "" "" ...
    ##  $ netr    : int  -58 -59 -59 -58 -58 -58 -57 -57 -59 -62 ...
    ##  $ f.netr  : chr  "" "" "" "" ...
    ##  $ bar     : int  1017 1017 1017 1017 1017 1017 1017 1017 1017 1016 ...
    ##  $ f.bar   : chr  "" "" "" "" ...
    ##  $ wspd    : num  2.6 2.3 2.1 1.8 1.4 1.6 1.5 1.5 1.6 1.7 ...
    ##  $ f.wspd  : chr  "" "" "" "" ...
    ##  $ wres    : num  2.4 2.1 1.8 1.6 1.2 1.4 1.3 1.4 1.4 1.6 ...
    ##  $ f.wres  : chr  "" "" "" "" ...
    ##  $ wdir    : int  205 213 217 226 224 214 214 213 217 214 ...
    ##  $ f.wdir  : chr  "" "" "" "" ...
    ##  $ wdev    : int  26 25 27 26 29 30 30 27 27 25 ...
    ##  $ f.wdev  : chr  "" "" "" "" ...
    ##  $ gspd    : num  7.2 5.9 5.8 5.1 4.6 4.4 5 4.2 4.2 4.6 ...
    ##  $ f.gspd  : chr  "" "" "" "" ...
    ##  $ s10t    : num  0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 0.7 ...
    ##  $ f.s10t  : chr  "" "" "" "" ...

These commands let you see the data and get some information about it. Notice
that data types that are not numbers or integers are classified as characters 
(chr), you specificed for R to recognize these as characters instead as factors
when you loaded the files by using the`stringsAsFactors=FALSE` command.  
However, there is information other than how R reads our data that we need to 
know. Can you think of any examples? 

To get some of this information, or clues to this information, we will open the
metadata text file that is in the AtmosData folder. Navigate to this file and 
open it in your text editor of choice.

![Harvard Forest 15 min Atmospheric Data Screenshot] (/Users/mjones01/Documents/Git_Repositories/NEON-R-Tabular-Time-Series/images)

Remember for this module we will be looking at air temperature, precipitation, 
and photosynthetically active radiation (PAR). Find these variables and 
identify what information the metadata tells you about them. 

We will add what we think is important from this metadata to our analysis here as 
comments in the script. These can be helpful if we share the R file with others or as 
notes to our future selves. Make notes that are intuitive and intelligible not only to 
yourself but to colleageus and collaborators as well.


    #Metadata Notes
    # column names for variables we are going to use: datetime, airt, prec, parr 
    # units for quantitative variables: celsius, millimeters, molePerMeterSquared
    # airt and parr are averages of measurements taken every 1 sec; precip is total of each 15 min period 
    #for quantitative variables missing values are given as NA

# Metadata Sleuthing
Questions: Is there information provided here that doesn't match what you see in
the data? Is there information you want to know that is not provided in this 
metadata file? Do you have ideas for how you might find that information?

Again, it is a good practice to make relevant notes from the metadata in your R
script so that you can easily refer to it as you actually work with the data.

Answer: No information is given for datetime besides that it is a date and time. It would be 
nice to know if it was recorded in UTC/GMT, or local time. Hopefully you noticed
that there is a link to the website at the top of the text file. Check it out to see if you can 
get the answer to your question.

The website gives more information that we have in our metadata file. And it 
gives us important information about datetime- all values are in Eastern Standard Time.

Again, it is a good practice to make relevant notes from the metadata in your R 
script so that you can easily refer to it as you actually work with the data.


    # website for more information: http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
    # date-times are in Eastern Standard Time
    # preview tab give plots of all variables

Bonus: Do you see anything else that might be related to metadata? 

Answer: EML file. This is the official standards-based metadata file using the 
Ecological Metadata Language (EML). Download this to your data folder. EML seems like an odd choice
but seeing this is an LTER site it makes sense because LTER uses EML extensively
in their projects.


    # EML file in the data folder now - all metadata information in there.

Now we have important information that will help us as we continue to use these
data for time series analysis.
