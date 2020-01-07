library(sf)
library(mapview)
library(pct)
library(tidyverse)

# wz = st_read("../NewDevelopmentsCycling/data/WorkplaceZonesFullExtent/Workplace_Zones_December_2011_Full_Extent_Boundaries_in_England_and_Wales.shp") %>% st_transform(27700)

wz = read_sf("http://geoportal1-ons.opendata.arcgis.com/datasets/a399c2a5922a4beaa080de63c0a218a3_1.geojson")

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)
iow = pct::get_pct_zones(region = "isle-of-wight", geography = "msoa", purpose = "commute") %>% st_transform(27700)

# wz_wyorks = st_intersection(wz,reszone) # this displays both x and y, with lots of splices
# wz_wyorks = st_crosses(wz,reszone) # this produces error 'Error in (function (classes, fdef, mtable)  : unable to find an inherited method for function ‘mapView’ for signature ‘"sgbp"’
wz_wyorks = st_intersection(wz,st_buffer(reszone,1000))

wz_simple = st_simplify(wz_wyorks,preserveTopology = TRUE, dTolerance = 10)

rz = st_boundary(reszone)

ggplot() +
  geom_sf(data = wz_wyorks)


mapview(reszone)
mapview(wz_wyorks)

################################
iow_whole = st_union(iow)
mapview(iow_whole)

wz_iow = wz[st_intersects(wz,iow_whole) == TRUE,]

wz[wz_iow == TRUE,]

mapview(wz_iow)

wz_wyorks = st_intersection(wz,reszone)


