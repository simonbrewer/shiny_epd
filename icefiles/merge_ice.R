## merge_ice
library(sf)

times <- seq(10000, 15000, by = 500)

for (i in 1:length(times)) {
  ice <- st_read(paste0("~/Dropbox/Data/epd/mapping/maps2010/ice_Europe/icee_",times[i],"/icee_",times[i],".shp"))
  ice$time <- times[i]
  
  if (i > 1) {
    ice_all <- rbind(ice_all, ice)
  } else {
    ice_all <- ice
  }
}

saveRDS(ice_all, file = "ice_all.rds")

## Quick map check
library(tmap)
ice_all %>%
  dplyr::filter(time == 10000) %>%
  tm_shape() + tm_borders()

ice_all %>%
  dplyr::filter(time == 13000) %>%
  tm_shape() + tm_borders()


