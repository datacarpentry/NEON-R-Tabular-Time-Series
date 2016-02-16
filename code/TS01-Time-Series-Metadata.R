## ----metadata-debrief----------------------------------------------------
#Metadata Notes from hf001_10-15-m_Metadata.txt
# column names for variables we are going to use: datetime, airt, prec, parr 
# units for quantitative variables: Celsius, millimeters, molePerMeterSquared
# airt and parr are averages of measurements taken every 1 sec; precip is total of each 15 min period 
# for quantitative variables missing values are given as NA

## ----install-EML-package, results="hide", warning=FALSE------------------
#install R EML tools
#library("devtools")
#install_github("ropensci/EML", build=FALSE, dependencies=c("DEPENDS", "IMPORTS"))

#load ROpenSci EML package
library("EML")
#load ggmap for mapping
library(ggmap)


#data location
#http://harvardforest.fas.harvard.edu:8080/exist/apps/datasets/showData.html?id=hf001
#table 4 http://harvardforest.fas.harvard.edu/data/p00/hf001/hf001-04-monthly-m.csv

## ----read-eml------------------------------------------------------------
#import EML from Harvard Forest Met Data
eml_HARV <- eml_read("http://harvardforest.fas.harvard.edu/data/eml/hf001.xml")

#view size of object
object.size(eml_HARV)

#view the object class
class(eml_HARV)

## ----view-eml-content----------------------------------------------------
#view the contact name listed in the file
#this works well!
eml_get(eml_HARV,"contact")

#grab all keywords in the file
eml_get(eml_HARV,"keywords")

#figure out the extent & temporal coverage of the data
eml_get(eml_HARV,"coverage")


## ----map-location, warning=FALSE, message=FALSE--------------------------
# grab x coordinate
XCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@westBoundingCoordinate
#grab y coordinate
YCoord <- eml_HARV@dataset@coverage@geographicCoverage@boundingCoordinates@northBoundingCoordinate


#map <- get_map(location='Harvard', maptype = "terrain")
map <- get_map(location='massachusetts', maptype = "toner", zoom =8)

ggmap(map, extent=TRUE) +
  geom_point(aes(x=XCoord,y=YCoord), 
             color="darkred", size=6, pch=18)


