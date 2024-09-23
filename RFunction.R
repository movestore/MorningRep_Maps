library("move2")
library("dplyr")
library('ggspatial')
library("ggplot2")
library('gridExtra')


# data <- readRDS("./data/raw/input2_move2loc_Mollweide.rds")
# time_now <- max(mt_time(data))
# time_dur <- 10

rFunction = function(time_now=NULL, time_dur=NULL, zoominVal=NULL, data) { 
  
  if (is.null(time_now)) {time_now <- Sys.time()} else {time_now <- as.POSIXct(time_now,format="%Y-%m-%dT%H:%M:%OSZ",tz="UTC")}
  
  time0 <- time_now - as.difftime(time_dur,units="days")
  
  dataPlot <-  data %>%
    group_by(mt_track_id()) %>%
    filter(mt_time() >= time0)
  
  if(nrow(dataPlot)>0){
    
    idall <- unique(mt_track_id(data))
    idsel <- unique(mt_track_id(dataPlot))
    if(!identical(idall, idsel)){logger.info(paste0("There are no locations available in the requested time window for track(s): ",paste0(idall[!idall%in%idsel], collapse = ", ")))}
    
    dataPlotTr <- split(dataPlot, mt_track_id(dataPlot))
    gpL <- lapply(dataPlotTr, function(trk){
      ggplot() +
        ggspatial::annotation_map_tile(zoomin = as.numeric(zoominVal)) +
        ggspatial::annotation_scale(aes(location="br")) +
        theme_linedraw() +
        geom_sf(data = mt_track_lines(trk),color = "black") +
        geom_sf(data = trk,  color="black", fill = "cyan", size = 2, shape=21)+
        geom_sf(data =slice_tail(trk,n = 5) , color="black", fill = "magenta", size =3, shape=21)+
        geom_sf(data =slice_tail(trk,n = 1) , color="black", fill = "magenta", size = 6, shape=21)+
        guides(color = "none")+
        labs(title = paste("Track:",unique(mt_track_id(trk)))) #+
      # theme(plot.margin=grid::unit(c(2,2,2,2), "cm"))
    })
    
    logger.info(paste0("Maps are produced for the individuals which have data in the requested time window: ",paste0(idsel, collapse = ", ")))
    gp <- marrangeGrob(gpL, nrow = 1, ncol = 1)
    ggsave(file=appArtifactPath("MorningReport_Maps.pdf"), plot = gp, width = 21, height = 29.7, units = "cm")
    
  }else{logger.info("None of the individuals have data in the requested time window. Thus, no pdf artefact is generated.")}
  
  return(data)
}
