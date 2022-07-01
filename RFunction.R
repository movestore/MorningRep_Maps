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
  
  Sys.setenv(tz="UTC")
  
  if (is.null(time_now)) time_now <- Sys.time() else time_now <- as.POSIXct(time_now,format="%Y-%m-%dT%H:%M:%OSZ",tz="UTC")
  
  data_spl <- move::split(data)
  ids <- namesIndiv((data))
  if (is.null(time_dur))
  {
    time_dur <- 10
    logger.info("You did not provide a time duration for your plot. It is defaulted by 10 days.")
  } #else  time_dur <- as.numeric(time_dur)
  time0 <- time_now - as.difftime(time_dur,units="days")

  g <- list()
  ids_g <- character()
  k <- 1
  for (i in seq(along=ids))
  {
    datai <- data_spl[[i]]
    datai_t <- datai[timestamps(datai)>=as.POSIXct(time0) & timestamps(datai)<=as.POSIXct(time_now),]   
    
    if (length(datai_t)>0)
    {
      datai_t.df <- as.data.frame(datai_t)
      names(datai_t.df) <- make.names(names(datai_t.df),allow_=FALSE)
      
      if (all(names(datai_t.df)!="location.long"))
      {
        coo <- data.frame(coordinates(datai_t))
        names(coo) <- c("location.long","location.lat")
        datai_t.df <- data.frame(as.data.frame(datai_t),coo)
      }

      bb <- bbox(datai_t)+c(-0.1,-0.1,0.1,0.1)
      m <- get_map(bb,maptype="terrain",source="osm")
      g[[k]] <- ggmap(m) +
      geom_path(data=datai_t.df,aes(x=location.long,y=location.lat),colour="orange") +
      geom_point(data=datai_t.df,aes(x=location.long,y=location.lat),colour=4,size=2,pch=20) +
      geom_point(data=tail(datai_t.df),aes(x=location.long,y=location.lat),colour=2,size=2,pch=20) +
      labs(title = paste("individual:",ids[i])) +
      theme(plot.margin=grid::unit(c(2,2,2,2), "cm"))
      ids_g <- c(ids_g,ids[i])
      k <- k+1
    } else logger.info(paste("There are no locations available in the requested time window for individual",ids[i]))
  }

  if (length(ids_g)>0)
  {
    logger.info(paste0("Maps are produced for the individuals ",paste(ids_g,collapse=", "),", which have data in the requested time window."))
    gp  <- marrangeGrob(g, nrow = 1, ncol = 1)
    ggsave(paste0(Sys.getenv(x = "APP_ARTIFACTS_DIR", "/tmp/"),"MorningReport_Maps.pdf"), plot = gp, width = 21, height = 29.7, units = "cm")
    #ggsave("MorningReport_Maps.pdf", gp, width = 21, height = 29.7, units = "cm")
  } else logger.info ("None of the individuals have data in the requested time window. Thus, no pdf artefact is generated.")

  return(data)
}
