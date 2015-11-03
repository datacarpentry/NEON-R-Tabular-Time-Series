## ----load-libraries------------------------------------------------------
# Load packages required for entire script
#library(nameOfLibrary)  #purpose of library

#set working directory
setwd("~/Documents/data/Spatio_TemporalWorkshop/1_WorkshopData")

## ----import-csv----------------------------------------------------------
# Load csv file of 15 min meterological data from Harvard Forest
# don't load strings (a series of letters or numerals) as factors so they remain
#characters
harMet15 <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
      stringsAsFactors = FALSE)

## ----look-at-data-structure----------------------------------------------
#to see first few lines of data file
head(harMet15)
#if you want to see it in spreadsheet form and scroll
View(harMet15)

#Check how R is seeing my data. What is the structure (str) of the data? 
#Is it what I expect to see?  
str(harMet15)


## ----metadata-debrief----------------------------------------------------
#Metadata Notes
# column names for variables we are going to use datetime, airt, prec, parr 
# units for quantitative variables: celsius, millimeters, molePerMeterSquared
# airt and parr are averages of measurements taken every 1 sec; precip is total 
  # of 15 min period for quantitative variables missing values are given as NA

## ----metadata-website----------------------------------------------------
# website for more information: http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
# date-times are in Eastern Standard Time
# preview tab give plots of all variables

## ----metadata-em-file----------------------------------------------------
# EML file in the data folder now - all metadata information in there.

