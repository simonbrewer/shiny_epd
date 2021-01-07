## Leaflet template map

library(sf)
library(leaflet)
library(dplyr)
library(RColorBrewer)

dat <- st_read("shpfiles/sites_654_Quercus.shp", quiet = TRUE)

dat <- dat %>% 
  filter(agebp == 0)

coords <- as.data.frame(st_coordinates(dat))
coords$freq <- dat$freq * 100
coords$ent <- dat$ent
# coords <- coords[1:100,]

qpal <- colorBin("YlOrRd", coords$freq, bins = 7, pretty = TRUE)


leaflet(coords) %>%
  addProviderTiles(providers$Stamen.TonerLite,
                   options = providerTileOptions(noWrap = TRUE)
  ) %>%
  addCircleMarkers(lat = ~Y, lng = ~X,
                   fillColor = ~qpal(freq), fillOpacity = 0.75,
                   radius = ~sqrt(freq) * 1.5, weight = 2,
                   popup = ~ent, 
                   color = "black", stroke = TRUE) %>%
  addLegend("topright", pal = qpal, values = ~freq, 
            title = "Perc", opacity = 0.75) 
  # addMarkers(data = coords)
