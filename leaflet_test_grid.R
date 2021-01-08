## Leaflet template map

library(sf)
library(leaflet)
library(dplyr)
library(RColorBrewer)
library(raster)

# dat <- st_read("shpfiles/sites_654_Quercus.shp", quiet = TRUE)

dat <- stack("./data/grid_654.nc")

pal <- colorNumeric(c("#E9F7EF", "#52BE80", "#145A32"), values(dat),
                    na.color = "transparent")

dat <- raster(dat, 10)

leaflet() %>%
  addProviderTiles(providers$Stamen.TonerLite,
                   options = providerTileOptions(noWrap = TRUE)
  ) %>%
  addRasterImage(dat, colors = pal, opacity = 0.8) %>%
  addLegend(pal = pal, values = values(r),
            title = "Abundance")
stop()

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
