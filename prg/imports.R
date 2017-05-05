# *******************************
# Import et creation d'un Rdata *
# *******************************

# [1] Import des couches

folder <- "https://raw.githubusercontent.com/riatelab/basemaps/master/Countries/Tunisia/geo"
file <- "TN-delegations.geojson"
url <- paste(folder,file,sep="/")
download.file(url, paste("data",file,sep="/"), method='auto')
file <- "TN-gouvernorats.geojson"
url <- paste(folder,file,sep="/")
download.file(url, paste("data",file,sep="/"), method='auto')
file <- "TN-countries.geojson"
url <- paste(folder,file,sep="/")
download.file(url, paste("data",file,sep="/"), method='auto')
file <- "TN-others.geojson"
url <- paste(folder,file,sep="/")
download.file(url, paste("data",file,sep="/"), method='auto')

# [2] Conversion des fond de cartes dans l'environnement de R

library("rgdal")

delegations.spdf <- readOGR(dsn = "data/TN-delegations.geojson", layer = "OGRGeoJSON")
gouvernorats.spdf <- readOGR(dsn = "data/TN-gouvernorats.geojson", layer = "OGRGeoJSON")
countries.spdf <- readOGR(dsn = "data/TN-countries.geojson", layer = "OGRGeoJSON")
others.spdf <- readOGR(dsn = "data/TN-others.geojson", layer = "OGRGeoJSON")

# [3] Projection cartographique

prj <- "+proj=utm +zone=32 +a=6378249.2 +b=6356515 +towgs84=-263,6,431,0,0,0,0 +units=m +no_defs"

delegations.spdf <- spTransform(x =  delegations.spdf, CRSobj = prj)
gouvernorats.spdf <- spTransform(x =  gouvernorats.spdf, CRSobj = prj)
countries.spdf <- spTransform(x =  countries.spdf, CRSobj = prj)
others.spdf <- spTransform(x =  others.spdf, CRSobj = prj)

# [4] Création de couches supplémentaires

shadow.spdf <- raster::shift(countries.spdf[countries.spdf@data$id=="TN",], 5000, -8000)
coastlines.sp <- as(rgeos::gBuffer(countries.spdf,byid=FALSE),'SpatialLines')

cartogram_pop2014.spdf <- readOGR(dsn = "data",layer="delegations_pop2014")
cartogramgouv_pop2014.spdf <- readOGR(dsn = "data",layer="gouvernorats_pop2014")

# [5] Export des couches dans le format Rdata

save(list = c("delegations.spdf","gouvernorats.spdf","countries.spdf","others.spdf","shadow.spdf","coastlines.sp","cartogram_pop2014.spdf","cartogramgouv_pop2014.spdf"), file = "data/geometriesTN.RData")


