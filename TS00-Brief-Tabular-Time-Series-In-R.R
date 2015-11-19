## ----load-libraries------------------------------------------------------
# Install packages required for entire script.
#install.packages(ggplot2)

# Load libraries required for entire script. 
# library(nameOfLibrary)  #purpose of library
library(ggplot2)   #efficient, pretty plotting - required to qplot function

#set working directory to ensure R can find the file we wish to import
#setwd("working-dir-path-here")


## ----import-csv----------------------------------------------------------

#Load csv file of daily meterological data from Harvard Forest
harMetdaily <- read.csv(file="AtmosData/HARV/hf001-06-daily-m.csv",
                     stringsAsFactors = FALSE)

#what type of R object is our imported data?
class(harMetdaily)


## ----view-data-structure-------------------------------------------------

#view first 6 rows of the dataframe 
head(harMetdaily)

#View the structure (str) of the data 
str(harMetdaily)

## ----plot-data-----------------------------------------------------------
#quickly plot of air temperature
qplot(x=date,y=airt, data=harMetdaily)


## ----view-field-structure------------------------------------------------
# View data structure for each column that we wish to plot
class(harMetdaily$date)

class(harMetdaily$airt)


## ----convert-date-time---------------------------------------------------

#convert field to date format
harMetdaily$date <- as.Date(harMetdaily$date)

#view results
head(harMetdaily$date)

#view structure of field
class(harMetdaily$date)


## ----qplot-data----------------------------------------------------------
#quickly plot the data and include a title
#In a string \n forces the string to break onto a new line
qplot(x=date,y=airt, 
      data=harMetdaily,
      main="Daily Air Temperature w Date Assigned\nNEON Harvard Forest")  


## ----challenge-code-plotting, echo=FALSE---------------------------------



