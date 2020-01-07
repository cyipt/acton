library(sf)
library(mapview)
library(pct)

workzone = st_read("../NewDevelopmentsCycling/data/WorkplaceZonesFullExtent/Workplace_Zones_December_2011_Full_Extent_Boundaries_in_England_and_Wales.shp")
wz = st_transform(workzone, 27700)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)
mapview(reszone)


st_crs(reszone)

wz_yworks = st_intersection(workzone,reszone)
