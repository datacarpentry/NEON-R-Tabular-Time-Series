## ----julian-day-convert--------------------------------------------------
# convert to julian days
# to learn more about it type
?yday

harMet_15Min$julian <- yday(harMet_15Min$datetime)  
#make sure it worked all the way through.  Dataframe was 30 variables so julian should be 31st.
head(harMet_15Min$julian) 
tail(harMet_15Min$julian)


