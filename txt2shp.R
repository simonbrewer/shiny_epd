## Make shapefiles
## Simply converts the old EPD text files to shp format for ease of use

library(sf)
library(dplyr)
library(tidyr)

epd_pvars <- read.csv("~/Dropbox/Data/epd/mapping/maps2010/selectPVarsMain.csv")

epd_pvars %>% 
  filter(Use == "Y")

site_files <- list.files("~/Dropbox/Data/epd/mapping/maps2010/maps/ok/datafiles/")

site_files

strsplit(site_files, "_")

for (i in 1:length(site_files)) {
  
  file_name <- tools::file_path_sans_ext(site_files[i])
  
  taxa_id <- strsplit(file_name, "_")[[1]][2]
  
  taxa_name <- epd_pvars$VarName[which(epd_pvars$Var. == taxa_id)]
  
  dat <- read.table(paste0("~/Dropbox/Data/epd/mapping/maps2010/maps/ok/datafiles/", 
                           site_files[i]),
                    header = TRUE)
  
  dat <- melt(dat, id.vars = c("ent", "lon", "lat", "alt"), 
              variable.name = "agebp", value.name = "freq") %>%
    filter(!is.na(freq))
  
  dat$agebp <- as.numeric(substr(dat$agebp, 2, 10))
  
  dat <- st_as_sf(dat, coords = c("lon", "lat"))
  
  st_crs(dat) <- 4326

  st_write(dat, paste0("shpfiles/", file_name, "_", taxa_name, ".shp"),
           driver = "ESRI Shapefile", append = FALSE)
}
