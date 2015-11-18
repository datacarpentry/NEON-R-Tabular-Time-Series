## ----load-libraries-data-------------------------------------------------
# Load packages required for entire script
# library(nameOfLibrary)  #purpose of library

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")

# Load csv file of 15 min meterological data from Harvard Forest
#Factors=FALSE so strings, a series of letters/ words/ numerals, remain characters
harMet_15min <- read.csv(file="AtmosData/HARV/hf001-10-15min-m.csv",
      stringsAsFactors = FALSE)

## ----look-at-data-structure----------------------------------------------
#to see first few lines of data file
head(harMet_15Min)

#to see it in spreadsheet form and scroll
#View(harMet15)

#Check how R is interpreting the data. What is the structure (str) of the data? 
#Is it what we expect to see?  
str(harMet_15Min)


## ----metadata-debrief----------------------------------------------------
#Metadata Notes from hf001_10-15-m_Metadata.txt
# column names for variables we are going to use: datetime, airt, prec, parr 
# units for quantitative variables: celsius, millimeters, molePerMeterSquared
# airt and parr are averages of measurements taken every 1 sec; precip is total of each 15 min period 
#for quantitative variables missing values are given as NA

## ----metadata-website----------------------------------------------------
# website for more information: http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
# date-times are in Eastern Standard Time
# preview tab give plots of all variables

## ----metadata-eml-file---------------------------------------------------
# EML file in the data folder now - all metadata information in there.

