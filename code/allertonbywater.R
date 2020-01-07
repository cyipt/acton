library(sf)
library(mapview)
library(pct)
library(tidyverse)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)

ab = st_sfc(st_polygon(list(cbind(c(441926,441865,442023,442362,442610,442613,442238,442297,442294,442197,442140,441968,441926),c(428055,427794,427620,427630,427579,427690,427906,428008,428094,428085,427954,428061,428055)))))
abc = st_sf(ab,crs = 27700)

mapview(abc) + mapview(reszone)
