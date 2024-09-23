# Morning Report Maps PDF
MoveApps

Github repository: *github.com/movestore/MorningRep_Maps*

## Description
This App creates a multipage PDF downloadable file with a (OpenStreetMap) map for each track for a given time duration (from end of track). So, you can see where your animals are and have been. 

## Documentation
This App plots each track that has data for the selected time interval on a OpenStreetMap background map. These plots are bundled in a PDF and can be downloaded as an output. The reference timestamp (either user-defined or by default NOW) is used as end timestamp, the selected time duration defines the back duration of locations shown in the map(s). All positions are shown as blue points, connected by black lines. The most recent 5 positions are highlighted in pink, and the very last location is larger in size, so that the present location of the animal can easily be picked out. The resolution of the map can be chosen to show more or less details.

### Application scope
#### Generality of App usability
This App was developed for any taxonomic group. It is specially useful to locate animals in the field by being able to plot the last locations.


#### Required data properties
The App should work for any kind of (location) data.

### Input type
`move2::move2_loc`

### Output type
`move2::move2_loc`

### Artefacts
`MorningReport_Maps.pdf`: PDF with a plot of a track on a map on each page.

### Settings 
**Reference time (`time_now`):** reference timestamp towards which all analyses are performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal or wanting to make sure that it is still doing fine. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window. 

**Track time duration (`time_dur`):** time duration into the past that the track has to be plotted for. So, if the time duration is selected as 5 days then the plotted track consists of all location from the reference timestamp to 5 days before it. Values can be also decimals, e.g. 0.25 for the last 6 hours. Unit: days

**Resolution of background map (`zoominVal`):** resolution of the background map. Options are "very low", "low", "high", "very high".


### Changes in output data
The input data remains unchanged.

### Most common errors

### Null or error handling
