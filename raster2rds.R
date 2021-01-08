## Convert raster to rds

library(raster)

#sppFile <- read.csv("./selectPVarsMain_07072011.csv")
sppFile <- read.csv("~/Dropbox/Data/epd/mapping/maps2010/selectPVarsMain.csv")
#sID <- which(sppFile$Use!="N")
#sID <- which(sppFile$VarCode == "Fag")
#sID <- which(sppFile$Use == "Y")
sID <- which(sppFile$Use == "Y" & !is.na(sppFile$q1))

mySpp = sppFile$Var.[sID]
sppSName = as.character(sppFile$VarCode[sID])
sppLName = as.character(sppFile$VarName[sID])
sppTHold = sppFile$Threshold[sID]

nspp <- length(mySpp)

for (i in 1:nspp) {
  r <- stack("~/Dropbox/Data/epd/mapping/maps2010/intmaps_v1/epdTaxaVals.nc", 
              varname = sppSName[i])
  
  writeRaster(r, paste0("./data/grid_", mySpp[i], ".nc"),
              varname ="freq", overwrite = TRUE, zname = "agebp")
}