library(sf)
library(mapview)
library(pct)
library(tidyverse)

wz = st_read("../NewDevelopmentsCycling/data/WorkplaceZonesFullExtent/Workplace_Zones_December_2011_Full_Extent_Boundaries_in_England_and_Wales.shp") %>% st_transform(27700)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)
mapview(reszone)

st_crs(reszone)

wz_wyorks = st_intersection(wz,reszone)

mapview(wz_wyorks)
