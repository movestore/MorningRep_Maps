# Morning Report pdf Maps
MoveApps

Github repository: *github.com/movestore/MorningRep_Maps*

## Description
This App creates a multipage pdf downloadable file with a (openstreet) map for each individual track for a given time duration (back). So, you can see where your animals are and have been. 

## Documentation
This App plots a leaflet map for each animal that has data in the selected time interval into a downloadable multipage pdf (artefact). The reference timestamp (either user-defined or by default NOW) is used as end timestamp, the selected time duration defines the back duration of locations shown in the map(s). All positions are shown as blue points, connected by orange lines. The most recent 5 positions are highlighted in red so that the present location of the animal can easily be picked out. The openstreetmap background map shows the terrain.The map is zoomed to the tracks.

### Input data
moveStack in Movebank format

### Output data
moveStack in Movebank format

### Artefacts
`MorningReport_Maps.pdf`: Artefact pdf with a map on each page showing the track of one animal.

### Parameters 
`time_now`: reference timestamp towards which all analyses are performed. Generally (and by default) this is NOW, especially if in the field and looking for one or the other animal or wanting to make sure that it is still doing fine. When analysing older data sets, this parameter can be set to other timestamps so that the to be plotted data fall into a selected back-time window. 

`time_dur`: time duration into the past that the track has to be plotted for. So, if the time duration is selected as 5 days then the plotted track consists of all location from the reference timestamp to 5 days before it. Unit: days

### Null or error handling:
**Parameter `time_now`:** If this parameter is left empty (NULL) the reference time is set to NOW. The present timestamp is extracted in UTC from the MoveApps server system.

**Parameter `time_dur`:** If this parameter is left empty (NULL) then by default 10 days is used. A respective warning is given.

**Artefact:** If there are no locations of any animals in the defined time window, a warning is given and no pdf artefact created.

**Data:** The data are not manipulated in this App, but plotted in a downloadable pdf. So that a possible Workflow can be continued after this App, the input data set is returned.