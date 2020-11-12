library('move')
library('foreach')
library('ggplot2')
library('reshape2')
library('tidyverse')
library('osmdata')
library('ggmap')
library('mapproj')
library('sf')
library('grid')
library('gridExtra')


rFunction = function(time_now=NULL, time_dur=NULL, data, ...) { 
  
  Sys.setenv(tz="GMT")
  
  if (is.null(time_now)) time_now <- Sys.time() else time_now <- as.POSIXct(time_now)
  
  data_spl <- move::split(data)
  ids <- namesIndiv((data))
  if (is.null(time_dur))
  {
    time_dur <- 10
    logger.info("You did not provide a time duration for your plot. It is defaulted by 10 days.")
  } else  time_dur <- as.numeric(time_dur)
  time0 <- time_now - as.difftime(time_dur,units="days")

  g <- list()
  k <- 1
  for (i in seq(along=ids))
  {
    datai <- data_spl[[i]]
    datai_t <- datai[timestamps(datai)>=as.POSIXct(time0) & timestamps(datai)<=as.POSIXct(time_now),] #diese Zeile gibt den Fehler!??? (läuft genauso aber in anderen Apps durch)
    datai_t.df <- datai_t@data #as.data.frame(data)
    
    if (length(datai_t)>0)
    {
      bb <- bbox(datai_t)+c(-0.1,-0.1,0.1,0.1)
      m <- get_map(bb,maptype="terrain",source="osm")
      g[[k]] <- ggmap(m) +
      geom_path(data=datai_t.df,aes(x=location_long,y=location_lat),colour="orange") +
      geom_point(data=tail(datai_t.df),aes(x=location_long,y=location_lat),colour=2,size=2,pch=20) +
      labs(title = paste("individual:",ids[i])) +
      theme(plot.margin=grid::unit(c(2,2,2,2), "cm"))
      k <- k+1
        
    } else {
      logger.info(paste0("There are no locations available in the requested time window for individual ",ids[i]))
    }
  }

  gp  <- marrangeGrob(g, nrow = 1, ncol = 1)
  ggsave(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"MorningReport_Maps.pdf"), plot = gp, width = 21, height = 29.7, units = "cm")
  #ggsave("MorningReport_Maps.pdf", gp, width = 21, height = 29.7, units = "cm")

  return(data)
}
