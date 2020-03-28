# Get developments built between 2000 and 2011

library(pct)
library(dplyr)
library(acton)


# Find homes built around 2000-2010 ---------------------------------------

# This is very strange. Whatever limit I choose, the number of applications returned is slightly below the limit.
large_old_apps = get_planit_data(auth = "leeds", app_size = "medium",app_state = "Permitted", end_date = "2005-01-01", limit = 500)
dim(large_old_apps)
View(large_old_apps)

readr::write_csv(large_old_apps, "large_old_apps.csv")
piggyback::pb_upload("large_old_apps.csv")


# Get OA boundary data ----------------------------------------------------

u = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/infuse_oa_lyr_2011_clipped.zip"

oas = ukboundaries::duraz(u = u)
# oas_pwc = ??? # would be good to get population weighted - it exists, not urgent priority
oas_centroids = sf::st_centroid(oas)
oas

leeds_27700 = ukboundaries::leeds %>% sf::st_transform(27700)
oas_leeds_centroids = oas_centroids[leeds_27700, ]
mapview::mapview(oas_leeds_centroids)
oas_leeds = oas %>%
  filter(geo_code %in% oas_leeds_centroids$geo_code)
saveRDS(oas_leeds, "oas_leeds.Rds")
piggyback::pb_upload("oas_leeds.Rds")
mapview::mapview(oas_leeds)

oas_leeds_simple_10 = oas_leeds %>%
  rmapshaper::ms_simplify(sys = T, keep = 0.1)

mapview::mapview(oas_leeds_simple_10)
# oas_centroid_ew = pct::get_centroids_ew() # msoa centroids
saveRDS(oas_leeds_simple_10, "oas_leeds_simple_10.Rds")
piggyback::pb_upload("oas_leeds_simple_10.Rds")

piggyback::pb_download_url("oas_leeds.Rds")
piggyback::pb_download_url("oas_leeds_simple_10.Rds")

oas_leeds = readRDS(url("https://github.com/cyipt/acton/releases/download/0.0.1/oas_leeds.Rds")) # why does this not work?


# Get travel data at OA (or LSOA) level -----------------------------------

# there are two approaches:
# 1  start with zone data
# 2  start with OD data and aggregate

# 1 - get travel data at zone level

allerton_bywater_oa_data = nomis_get_data(id = "NM_568_1", geography = c( "1254262620","1254262621","1254262622"), measures = "20100", rural_urban="0")

allerton_bywater_oa_data = allerton_bywater_oa_data %>%
  select(GEOGRAPHY, GEOGRAPHY_CODE, CELL, CELL_NAME, MEASURES, MEASURES_NAME, OBS_VALUE, OBS_STATUS, OBS_STATUS_NAME, OBS_CONF, OBS_CONF_NAME)

# there are two different ways the same geography can be specified
allerton_bywater = c("E00170565", "E00170564", "E00170567")
chapelford = c("E00063394", "E00172881", "E00172882", "E00172884", "E00172889", "E00172890", "E00172892", "E00172895", "E00172896", "E00173169", "E00173170")
dickens_heath = c("E00168165", "E00168166", "E00168167", "E00168168", "E00168169", "E00168170", "E00168171", "E00168172", "E00168175", "E00168173", "E00168177", "E00168176", "E00168178", "E00168174", "E00051490")
newc_great_park = c("E00175566", "E00175567", "E00175568", "E00175569", "E00175570", "E00175573", "E00175591", "E00175572", "E00042147")
paxcroft = c("E00166462", "E00166415", "E00166413", "E00163729", "E00166403", "E00166406", "E00166338", "E00163618", "E00163617")
poundbury = c("E00166094", "E00166095", "E00166096", "E00166097", "E00166098", "E00166099", "E00166086", "E00166084", "E00104084")
upton = c("E00169237", "E00169240", "E00169239", "E00169242")
wichelstowe = c("E00166484", "E00166486", "E00166485")
wynyard = c("E00061995", "E00174145", "E00174146", "E00174147", "E00174188", "E00174185", "E00060314")
hamptons = c("E00171289", "E00171291", "E00171254", "E00171256", "E00171257", "E00171319", "E00171260", "E00171272", "E00171275", "E00171276", "E00171284", "E00171295", "E00171322", "E00171323", "E00171330", "E00171320", "E00171271", "E00171273", "E00171277", "E00171302", "E00171308", "E00171321", "E00171299", "E00171274", "E00171298", "E00171300", "E00171301", "E00171303", "E00171304", "E00171306", "E00171307", "E00171290", "E00171285", "E00171286", "E00171292", "E00171305", "E00171315", "E00171316", "E00171317", "E00171318", "E00171288", "E00171253", "E00171255", "E00171278", "E00171293", "E00171294", "E00171296", "E00171297", "E00171309", "E00171310", "E00171311", "E00171312", "E00171313", "E00171314", "E00171324")
wixams = c("E00173781", "E00173782", "E00173784")
stockmoor = c("E00165964", "E00165966", "E00165967", "E00165975")

# ladcode = "E01033181"
# oacodes = getsubgeographies(ladcode, "OA11")
# oacodes

geog_new_homes = c(allerton_bywater, chapelford, dickens_heath, newc_great_park, paxcroft, poundbury, upton, wichelstowe, wynyard, hamptons, wixams, stockmoor)

all_sites = list(allerton_bywater, chapelford, dickens_heath, newc_great_park, paxcroft, poundbury, upton, wichelstowe, wynyard, hamptons, wixams, stockmoor)


oa_data_all = nomis_get_data(id = "NM_568_1", geography = geog_new_homes, measures = "20100", rural_urban="0")

dim(oa_data_all)

oa_data_all = oa_data_all %>%
  select(GEOGRAPHY, GEOGRAPHY_CODE, GEOGRAPHY_TYPE, GEOGRAPHY_TYPECODE, CELL, CELL_NAME, MEASURES, MEASURES_NAME, OBS_VALUE, OBS_STATUS, OBS_STATUS_NAME, OBS_CONF, OBS_CONF_NAME) %>%
  inner_join(oas, by = c("GEOGRAPHY" = "geo_code"))
oa_data_all = st_as_sf(oa_data_all)

dim(oa_data_all)

# Create SITE variable identifying which site the row belongs to
library(data.table)
LDT = rbindlist(lapply(all_sites, data.table), idcol = TRUE)
oa_data_all = inner_join(oa_data_all,LDT, by = c("GEOGRAPHY" = "V1")) %>%
  rename(SITE = .id)


# Getting LSOA codes ------------------------------------------------------

# lsoa = pct::get_pct_zones(region = "west-yorkshire")

u = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/England_lsoa_2011_clipped.zip"

lsoas = ukboundaries::duraz(u = u)
# oas_pwc = ??? # would be good to get population weighted - it exists, not urgent priority
lsoas_centroids1 = get_pct_centroids(region = "west-yorkshire", geography = "lsoa")
lsoas_centroids2 = get_pct_centroids(region = "cheshire", geography = "lsoa")
lsoas_centroids3 = get_pct_centroids(region = "north-east", geography = "lsoa")
lsoas_centroids4 = get_pct_centroids(region = "wiltshire", geography = "lsoa")
lsoas_centroids5 = get_pct_centroids(region = "cambridgeshire", geography = "lsoa")
lsoas_centroids6 = get_pct_centroids(region = "west-midlands", geography = "lsoa")
lsoas_centroids7 = get_pct_centroids(region = "dorset", geography = "lsoa")
lsoas_centroids8 = get_pct_centroids(region = "northamptonshire", geography = "lsoa")
lsoas_centroids9 = get_pct_centroids(region = "bedfordshire", geography = "lsoa")
lsoas_centroids10 = get_pct_centroids(region = "somerset", geography = "lsoa")

lsoas_centroids = rbind(lsoas_centroids1, lsoas_centroids2, lsoas_centroids3, lsoas_centroids4, lsoas_centroids5, lsoas_centroids6, lsoas_centroids7, lsoas_centroids8, lsoas_centroids9, lsoas_centroids10) %>%
  select(geo_code, geometry)



# Join the OA data to LSOA geo_codes
oa_data_centroids = sf::st_centroid(oa_data_all)
joined = sf::st_join(oa_data_centroids, lsoas)
names(joined)
dim(joined)

# Join the result to the LSOA centroid geometry
joined = st_drop_geometry(joined)
joined2 = inner_join(joined, lsoas_centroids, by = c("code" = "geo_code"))

# Get the list of LSOA geo_codes being used
geo_codes_used = unique(joined2$code)


# Routing -----------------------------------------------------------------

#Get desire lines from LSOA centroids to workplaces

lines_leeds = pct::get_pct_lines(region = "west-yorkshire", geography = "lsoa")
lines_warrington = pct::get_pct_lines(region = "cheshire", geography = "lsoa")
lines_northeast = pct::get_pct_lines(region = "north-east", geography = "lsoa")
lines_wiltshire = pct::get_pct_lines(region = "wiltshire", geography = "lsoa")
lines_cambridgeshire = pct::get_pct_lines(region = "cambridgeshire", geography = "lsoa")
lines_westmids = pct::get_pct_lines(region = "west-midlands", geography = "lsoa")
lines_dorset = pct::get_pct_lines(region = "dorset", geography = "lsoa")
lines_northants = pct::get_pct_lines(region = "northamptonshire", geography = "lsoa")
lines_bedford = pct::get_pct_lines(region = "bedfordshire", geography = "lsoa")
lines_somerset = pct::get_pct_lines(region = "somerset", geography = "lsoa")

lines_all = rbind(lines_leeds, lines_warrington, lines_northeast, lines_wiltshire, lines_cambridgeshire, lines_westmids, lines_dorset, lines_northants, lines_bedford, lines_somerset) %>%
  unique()


##

# Where geo_code1 is in the site
lines_1 = lines_all %>%
  select(geo_code1, geo_code2, all, bicycle, foot, car_driver
         # dutch_slc etc
  ) %>%
  filter(geo_code1 %in% geo_codes_used)

dim(lines_1)

# Where geo_code2 is in the site
`%notin%` <- Negate(`%in%`)

lines_2 = lines_all %>%
  select(geo_code1, geo_code2, all, bicycle, foot, car_driver
         # dutch_slc etc
  ) %>%
  filter(geo_code2 %in% geo_codes_used & geo_code1 %notin% geo_codes_used) %>%
  rename(geo_code1 = geo_code2, geo_code2 = geo_code1)

dim(lines_2)

lines_both = rbind(lines_1, lines_2)

dim(lines_both)

# Adding in the site ID
site_id = joined2 %>%
  select(c(code, SITE)) %>%
  unique()

lines_both = inner_join(lines_both,site_id, by = c("geo_code1" = "code"))

mapview(lines_both)


# Convert the lines into routes-------------------------------------------------


library(parallel)
cl <- makeCluster(detectCores())
clusterExport(cl, c("journey"))#not needed and not working
routes_to_site = route(l = lines_both, route_fun = cyclestreets::journey)

mapview(routes_to_site)

## Create route network
routes_to_site$busyness = routes_to_site$busynance / routes_to_site$distances

r_grouped_census = routes_to_site %>%
  rename(fx = start_longitude, fy = start_latitude, tx = finish_longitude, ty = finish_latitude) %>%
  group_by(fx, fy, tx, ty) %>%
  summarise(
    n = n(),
    all = mean(all),
    average_incline = sum(abs(diff(elevations))) / sum(distances),
    distance_m = sum(distances),
    busyness = mean(busyness)
  ) %>%
  ungroup()


# summary(r_grouped)

r_grouped_census$go_dutch = pct::uptake_pct_godutch(distance = r_grouped_census$distance_m, gradient = r_grouped_census$average_incline) *
  r_grouped_census$all
r_grouped_lines_census = r_grouped_census %>% st_cast("LINESTRING")
rnet_go_dutch_census = overline2(r_grouped_lines_census, "go_dutch")

# routes_to_site_census = routes_to_site
rnet_all_census = overline2(routes_to_site, "all")

# summary(rnet_go_dutch$go_dutch)

library(tmap)
tmap_mode("view")

tm_shape(rnet_go_dutch_census) +
  tm_lines("go_dutch", lwd = "go_dutch", scale = 9, palette = "plasma", breaks = c(0, 10, 50, 100, 200))

tm_shape(rnet_all_census) +
  tm_lines("all", lwd = "all", scale = 9, palette = "plasma", breaks = c(0, 10, 50, 100, 200))


# create model estimating mode share --------------------------------------

?pct::uptake_pct_govtarget

# logit (pcycle) = -3.959 +   # alpha
#   (-0.5963 * distance) +    # d1
#   (1.866 * distancesqrt) +  # d2
#   (0.008050 * distancesq) + # d3
#   (-0.2710 * gradient) +    # h1
#   (0.009394 * distance * gradient) +  # i1
#   (-0.05135 * distancesqrt *gradient) # i2

# m = glm(formula = pcycle ~ distance + sqrt(distance) + gradient + circuity_cycling + road_speeds1,
#     family = quasibinomial)
# pcycle = predict(m, new_data)
# boot::inv.logit(pcycle) # to get back to percent

ladcode = "E09000001" # City of London
oacodes = getsubgeographies(ladcode, "OA11")
