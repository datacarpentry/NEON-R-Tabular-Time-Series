## ----set-width-----------------------------------------------------------
# output will have width of 80 max
options(width=80)

## ----PAR-v-precip--------------------------------------------------------

part.prec <- ggplot(harMet.daily,aes(prec, part)) +
           geom_point() +
           ggtitle("Relationship between precipitation and PART") +
           theme(plot.title = element_text(lineheight=.8, face="bold",size = 20)) +
           theme(text = element_text(size=20)) +
           xlab("Total Precipitation") + ylab("Mean Total PAR")


## ----subsetting-by-season------------------------------------------------

#subset by season using month (12-2 is winter, 3-5 spring, 6-8 summer, 9-11 fall)


## ----plot-by-season------------------------------------------------------

#part.prec + facet_grid(. ~ season)
#part.prec + facet_grid(season ~ .)

#part.prect + facet_wrap(~season, ncol = 2)


