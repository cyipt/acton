library(rgdal)
retail = readOGR("Z:/Data/retailcentrecentroids.gpkg")
mapview(retail)

head(retail)
summary(retail)
