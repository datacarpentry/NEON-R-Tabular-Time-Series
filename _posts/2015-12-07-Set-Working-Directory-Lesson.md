---
layout: post
title: "Setting A Working Directory In R"
date:   2015-12-07
lastModified: 2015-12-08
createddate:   2015-12-07
estimatedTime: 5 Min
authors: Megan A. Jones
categories: [coding-and-informatics]
category: coding-and-informatics
tags: [R]
mainTag: 
description: "This lesson explains how to set the Working Directory in R to a 
folder of downloaded data files. "
code1: 
image:
  feature: hierarchy_folder_purple.png
  credit: Colin Williams NEON, Inc.
  creditlink: http://www.neoninc.org
permalink: /R/Set-Working-Directory/
comments: false
---

{% include _toc.html %}

##About
This lesson explains how to set the working directory in R to a folder of data
downloaded to a local folder.

**R Skill Level:** Beginner

<div id="objectives" markdown="1">

### Goals / Objectives
After completing this activity, you will:

 * Be able set the `R` Working Directory to a folder of downloaded data.

###Things You'll Need To Complete This Lesson
Please be sure you have the most current version of `R` and, preferably
RStudio, to write your code.

####Data to Download
<a href="http://files.figshare.com/2437700/AtmosData.zip" class="btn btn-success">
Download Atmospheric Data</a>

The data used in this lesson were collected at Harvard Forest which is
an National Ecological Observatory Network  
<a href="http://www.neoninc.org/science-design/field-sites/harvard-forest" target="_blank"> field site</a>. 
These data are proxy data for what will be available for 30 years
on the [NEON data portal](http://data.neoninc.org/ "NEON data")
for both Harvard Forest and other field sites located across the United States.

</div>

#NEON Data Skills Lessons
Most of the data skills lessons available through the [NEON Data Skills portal](http://www.NEONdataskills.org  "#WorkWithData")
utilize one or more data sets that are is available for download within each 
lesson under the **Data** **to** **Download** section.  These data 
subsets are hosted on the NEON Data Skills Figshare site and are freely 
available.  Prior to being able to start the lesson we must set the `R` Working
Directory to the location of these files.  

#Download the Data
After clicking on the "Download Data Set" button, the data (**AtmosData.zip**) 
will automatically download.  Most of the time the data files will be contained 
within a zipped folder.
Unless you have set up your computer differently, these downloaded files will be
in your *Downloads* Folder.  

While you can leave the data in the *Downloads* Folder many people prefer to
have
a separate folder where all the data for specific projects is stored.  For the
purposes of this lesson we will say that we have a folder *data* within our
*Documents* folder where we will move and save the downloaded **AtmosData**.  



Use a program already installed on your computer, or one of many free unzipping 
programs that can be readily downloaded, to unzip the folder.  

#Check Current Working Directory
The code `getwd()` can be typed into the R console at any point to determine
where the current Working Directory is set.  

#Written Path
Pathways in the NEON Data Skills lessons will be written assuming the working
directory is the parent directory to the folder that was downloaded. {: .notice1}

Therefore, we are going to be setting our
Working Directory to the *data* folder within our *Documents* folder.  

Pathways for different operating systems are slightly different.  For
explanation purposes we have a:
 
 * user named: NEON
 * initial folder: Documents
 * second folder: data
 * third folder: AtmosData

Our goal is to set the working directory to *data* so that all pathways with our
code can start with the AtmosData folder that was downloaded.  

## Windows
setwd("C:/Users/NEON/Documents/data/")

## Mac
setwd("/Users/NEON/Documents/data")

If you are unsure of the pathway you can find out by right clicking (Mac: 
control+click) on the file/folder of interest and select "Get Info". There 
location information will appear something like: 

Computer > Users > NEON > Documents > data > AtmosData

if you copy and paste that information it automatically turns into the path to
that folder: 

Windows:  C:/Users/NEON/Documents/data/AtmosData/
Mac:  /Users/NEON/Documents/data/AtmosData

#Using RStudio GUI
Windows or Mac Operating System: go to Session, select Select Working Directory, select Choose Directory, and select the appropraite folder/directory. 

#Using R GUI
Windows Operating Systems: go to the File menu, select Change Working Directory, and select the appropriate folder/directory.

Mac Operating Systems: go to the Misc menu, select Change Working Directory, and select the appropriate folder/directory


