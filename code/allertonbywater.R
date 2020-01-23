library(sf)
library(mapview)
library(pct)
library(tidyverse)
library(acton)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% rename(LA_Code = lad11cd)

st_is_valid(reszone)
resszone = lwgeom::st_make_valid(reszone)
st_is_valid(reszone)

c = pct::get_pct_centroids(region = "west-yorkshire", geography = "lsoa") %>% rename(LA_Code = lad11cd)

reszone = reszone %>% filter(LA_Code == "E08000035")
c = c %>% filter(LA_Code == "E08000035")

# Allerton Bywater Millennium Community polygon ---------------------------

ab = st_sfc(st_polygon(list(cbind(c(441926,441865,442023,442362,442610,442613,442238,442297,442294,442197,442140,441968,441926),c(428055,427794,427620,427630,427579,427690,427906,428008,428094,428085,427954,428061,428055)))))
abc = st_sf(ab,crs = 27700)
abc$n_homes = 562

# additional variables

abc_4326 = st_transform(abc, 4326)
#
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

# access_town = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_town.Rds")
# access_food = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_food.Rds")
# access_employ = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_employ.Rds")
# access_primary = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_primary.Rds")
# access_secondary = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_secondary.Rds")
# access_gp = readRDS("~/NewDevelopmentsCycling/data/accessibility/access_gp.Rds")

# wy = unique(reszone$lad11cd)
# access_town_wy = access_town[access_town$LA_Code %in% wy,]

access_employ = get_jts_data("jts0501", 2017)
access_town = get_jts_data("jts0508", 2017)#error
access_food = get_jts_data("jts0507", 2017)
access_primary = get_jts_data("jts0502", 2017)
access_secondary = get_jts_data("jts0503", 2017)
access_gp = get_jts_data("jts0505", 2017)#error


# Weighted employment figures ---------------------------------

access_employ$weightedJobsPTt = apply(
  X = access_employ[c("Jobs100EmpPTt", "Jobs500EmpPTt", "Jobs5000EmpPTt")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)
access_employ$weightedJobsCyct = apply(
  X = access_employ[c("Jobs100EmpCyct", "Jobs500EmpCyct", "Jobs5000EmpCyct")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)
access_employ$weightedJobsCart = apply(
  X = access_employ[c("Jobs100EmpCart", "Jobs500EmpCart", "Jobs5000EmpCart")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)


# Join the data tables ----------------------------------------------------

reszone = inner_join(reszone,access_town,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_food,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_employ,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_primary,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_secondary,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_gp,by = c("geo_code" = "LSOA_code","LA_Code"))


# PlanIt data for Allerton Bywater and other sites--------------------------------------------

# ?get_planit_data #####should work once I can download the acton package


# https://www.planit.org.uk/planapplic/13/05235/FU@Leeds/geojson ## the full URL for alleron bywater in planit
#
# base = "https://www.planit.org.uk/"
# endpoint = "planapplic/13/05235/FU@Leeds/geojson"
# call1 = paste(base,endpoint, sep = "")
#
# library(geojsonsf)
#
# planit_ab = geojson_sf(call1)
# head(planit_ab)
#
# planit_ab_proj = st_transform(planit_ab,27700)

# get_planit_data(bbox = NULL, pcode = "LS2 9JT", limit = 2) # data from specific postcode

# library(httr)
# library(jsonlite)
#
# get_ab = GET(call1)
#
# get_ab_text = content(get_ab, "text")
# get_ab_json = fromJSON(get_ab_text, flatten = TRUE)
#
# get_ab_df = as.data.frame(get_ab_json$properties)
# st_as_sf(get_ab_df, coords = c(get_ab_df$lat, get_ab_df$lng))#fails



##########

p1 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "13/05235/FU@Leeds", base_url = "https://www.planit.org.uk/")
p2 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/04151/FU@Leeds", base_url = "https://www.planit.org.uk/")
p3 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/01973/FU@Leeds", base_url = "https://www.planit.org.uk/")
p4 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/00415/FU@Leeds", base_url = "https://www.planit.org.uk/")

p4 = p4[,-9]


sites = rbind(p1,p2,p3,p4)
sites$place = c("AllertonBywater", "Tyersall", "Micklefield", "LeedsClimateInnovationDistrict")



# Link the sites with the closest centroid --------------------------------


# # this joins the sites with the LSOA they sit within, but I think it would be better to join them with the closest LSOA centroid instead, since it is the centroids that are used as the origin points for the accessibility stats
# reszone_proj = reszone %>% st_transform(27700)
#
# sites = sites %>%
#   st_transform(27700)
# sites = st_join(sites,reszone_proj,join = st_within) %>%
#   st_transform(4326)


# this finds the nearest centroid to each site
c_proj = c %>% st_transform(27700)

sites = sites %>%
  st_transform(27700)
sites = st_join(sites,c_proj,join = st_nearest_feature) %>%
  st_transform(4326)

# sites$nearest_centroid = sites %>%
#   st_transform(27700)
# st_nearest_feature(near,c_proj) %>%
#   st_transform(4326)


sites$geo_code

# mapview(abc) +
mapview(reszone) +
mapview(sites) +
mapview(c[c$geo_code %in% sites$geo_code,])



# Maps --------------------------------------------------------------------

library(tmap)
tmap_mode("view")

#Warning - geometry is not valid on row 359
# reszone[which(st_is_valid(reszone) == FALSE),]


#Accessibility stat examples
tm_shape(reszone) +
  tm_polygons(col = "FoodPTt") +
  tm_shape(sites) +
  tm_dots() +
  tm_shape(c) +
  tm_dots(col = "yellow")


tm_shape(reszone) +
  tm_polygons(col = "FoodCyct") +
  tm_shape(sites) +
  tm_dots()

tm_shape(reszone) +
  tm_polygons(col = "FoodCart") +
  tm_shape(sites) +
  tm_dots()

tm_shape(reszone) +
  tm_polygons(col = "weightedJobsPTt") +
  tm_shape(sites) +
  tm_dots()

tm_shape(reszone) +
  tm_polygons(col = "weightedJobsCyct") +
  tm_shape(sites) +
  tm_dots()

tm_shape(reszone) +
  tm_polygons(col = "weightedJobsCart") +
  tm_shape(sites) +
  tm_dots()



