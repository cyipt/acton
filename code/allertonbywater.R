library(sf)
library(mapview)
library(pct)
library(tidyverse)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700)

ab = st_sfc(st_polygon(list(cbind(c(441926,441865,442023,442362,442610,442613,442238,442297,442294,442197,442140,441968,441926),c(428055,427794,427620,427630,427579,427690,427906,428008,428094,428085,427954,428061,428055)))))
abc = st_sf(ab,crs = 27700)
abc$n_homes = 562

# additional variables

abc_4326 = st_transform(abc, 4326)

lwgeom::st_geod_area(abc_4326)
st_area(abc_4326)
st_area(abc) # why are these not the same?

# abc_buffer = st_buffer(abc, 500)
# abc_buffer2 = abc_4326 %>%
#   st_transform(27700) %>%
#   st_buffer(500) %>%
#   st_transform(4326)
#
# abc_buffer3 = stplanr::geo_projected(abc_4326, st_buffer, dist = 500)
#
# mapview(abc_buffer) + mapview(abc_buffer2) + mapview(abc_buffer3)

mapview(abc) + mapview(reszone)



# Accessibility stats -----------------------------------------------------

access_town = readRDS("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/data-prepared/access_town.Rds")
access_food = readRDS("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/data-prepared/access_food.Rds")

# wy = unique(reszone$lad11cd)
# access_town_wy = access_town[access_town$LA_Code %in% wy,]

reszone = inner_join(reszone,access_town,by = c("geo_code" = "LSOA_code"))
reszone = inner_join(reszone,access_food,by = c("geo_code" = "LSOA_code"))


wymap = reszone[,c(3,131,140)]

library(tmap)
tmap_mode("view")

tm_shape(reszone) +
  tm_polygons(col = "FoodPTt")



