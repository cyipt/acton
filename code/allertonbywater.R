library(sf)
library(mapview)
library(pct)
library(tidyverse)

reszone = pct::get_pct_zones(region = "west-yorkshire", geography = "lsoa", purpose = "commute") %>% st_transform(27700) %>% rename(LA_Code = lad11cd)

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

access_town = readRDS("../NewDevelopmentsCycling/data/accessibility/access_town.Rds")
access_food = readRDS("../NewDevelopmentsCycling/data/accessibility/access_food.Rds")
access_employ = readRDS("../NewDevelopmentsCycling/data/accessibility/access_employ.Rds")
access_primary = readRDS("../NewDevelopmentsCycling/data/accessibility/access_primary.Rds")
access_secondary = readRDS("../NewDevelopmentsCycling/data/accessibility/access_secondary.Rds")
access_gp = readRDS("../NewDevelopmentsCycling/data/accessibility/access_gp.Rds")

# wy = unique(reszone$lad11cd)
# access_town_wy = access_town[access_town$LA_Code %in% wy,]

reszone = inner_join(reszone,access_town,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_food,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_employ,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_primary,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_secondary,by = c("geo_code" = "LSOA_code","LA_Code"))
reszone = inner_join(reszone,access_gp,by = c("geo_code" = "LSOA_code","LA_Code"))


# Allerton Bywater PlanIt data --------------------------------------------

# ?get_planit_data


# https://www.planit.org.uk/planapplic/13/05235/FU@Leeds/geojson

base = "https://www.planit.org.uk/"
endpoint = "planapplic/13/05235/FU@Leeds/geojson"
call1 = paste(base,endpoint, sep = "")



p1 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "13/05235/FU@Leeds", base_url = "https://www.planit.org.uk/")
p2 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/04151/FU@Leeds", base_url = "https://www.planit.org.uk/")
p3 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/01973/FU@Leeds", base_url = "https://www.planit.org.uk/")
p4 = get_planit_data(bbox = NULL, query_type = "planapplic", query_type_search = "15/00415/FU@Leeds", base_url = "https://www.planit.org.uk/")

sites

get_planit_data(bbox = NULL, pcode = "LS2 9JT", limit = 2) # data from specific postcode


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

library(geojsonsf)

planit_ab = geojson_sf(call1)
head(planit_ab)

planit_ab_proj = st_transform(planit_ab,27700)

##now need to identify which LSOA planit_ab_proj falls within

# planit_ab_proj$region <- apply(st_intersects(reszone, planit_ab_proj, sparse = FALSE), 2,
#                      function(col) {
#                        reszone[which(col), ]$LSOA_code
#                      })
#
# planit_ab_proj$region

planit_ab_proj = st_join(planit_ab_proj,reszone,join = st_within)

planit_ab_proj$geo_code
planit_ab_proj$LA_Code
planit_ab_proj$FoodPTt

mapview(planit_ab_proj)


# Maps --------------------------------------------------------------------


library(tmap)
tmap_mode("view")

#Warning - geometry is not valid on row 359
# reszone[which(st_is_valid(reszone) == FALSE),]

#Accessibility stat examples
tm_shape(reszone) +
  tm_polygons(col = "FoodPTt") +
  tm_shape(planit_ab_proj) +
  tm_dots()


tm_shape(reszone) +
  tm_polygons(col = "FoodCyct")

tm_shape(reszone) +
  tm_polygons(col = "5000EmpPTt")

tm_shape(reszone) +
  tm_polygons(col = "500EmpPTt")

tm_shape(reszone) +
  tm_polygons(col = "100EmpPTt")

tm_shape(reszone) +
  tm_polygons(col = "5000EmpCyct")

tm_shape(reszone) +
  tm_polygons(col = "500EmpCyct")

tm_shape(reszone) +
  tm_polygons(col = "100EmpCyct")




