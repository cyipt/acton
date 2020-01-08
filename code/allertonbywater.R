library(sf)
library(mapview)
library(pct)
library(tidyverse)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)

ab = st_sfc(st_polygon(list(cbind(c(441926,441865,442023,442362,442610,442613,442238,442297,442294,442197,442140,441968,441926),c(428055,427794,427620,427630,427579,427690,427906,428008,428094,428085,427954,428061,428055)))))
abc = st_sf(ab,crs = 27700)
abc$n_homes = 560

# additional variables

abc_4326 = st_transform(abc, 4326)
st_area(abc_4326)
abc_buffer = st_buffer(abc, 500)
abc_buffer2 = abc_4326 %>%
  st_transform(27700) %>%
  st_buffer(500) %>%
  st_transform(4326)

abc_buffer3 = stplanr::geo_projected(abc_4326, st_buffer, dist = 500)

mapview(abc_buffer) + mapview(abc_buffer2) + mapview(abc_buffer3)

mapview(abc) + mapview(reszone)
