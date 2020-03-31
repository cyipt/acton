# Get developments built between 2000 and 2011

library(pct)
library(dplyr)
library(acton)
library(nomisr)
library(sf)
library(ukboundaries)

# Find homes built around 2000-2010 ---------------------------------------

# # This is very strange. Whatever limit I choose, the number of applications returned is slightly below the limit.
# large_old_apps = get_planit_data(auth = "leeds", app_size = "medium",app_state = "Permitted", end_date = "2005-01-01", limit = 500)
# dim(large_old_apps)
# View(large_old_apps)
#
# readr::write_csv(large_old_apps, "large_old_apps.csv")
# piggyback::pb_upload("large_old_apps.csv")


# Get OA boundary data ----------------------------------------------------

u = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/infuse_oa_lyr_2011_clipped.zip"

oas = ukboundaries::duraz(u = u)
# oas_pwc = ??? # would be good to get population weighted - it exists, not urgent priority
oas_centroids = sf::st_centroid(oas) %>%
  st_transform(4326)
oas

# leeds_27700 = ukboundaries::leeds %>% sf::st_transform(27700)
# oas_leeds_centroids = oas_centroids[leeds_27700, ]
# mapview::mapview(oas_leeds_centroids)
# oas_leeds = oas %>%
#   filter(geo_code %in% oas_leeds_centroids$geo_code)
# saveRDS(oas_leeds, "oas_leeds.Rds")
# piggyback::pb_upload("oas_leeds.Rds")
# mapview::mapview(oas_leeds)
#
# oas_leeds_simple_10 = oas_leeds %>%
#   rmapshaper::ms_simplify(sys = T, keep = 0.1)
#
# mapview::mapview(oas_leeds_simple_10)
# # oas_centroid_ew = pct::get_centroids_ew() # msoa centroids
# saveRDS(oas_leeds_simple_10, "oas_leeds_simple_10.Rds")
# piggyback::pb_upload("oas_leeds_simple_10.Rds")
#
# piggyback::pb_download_url("oas_leeds.Rds")
# piggyback::pb_download_url("oas_leeds_simple_10.Rds")
#
# oas_leeds = readRDS(url("https://github.com/cyipt/acton/releases/download/0.0.1/oas_leeds.Rds")) # for readRDS you need to specify url()
#
#
# # Get travel data at OA (or LSOA) level -----------------------------------
#
# # there are two approaches:
# # 1  start with zone data
# # 2  start with OD data and aggregate
#
# # 1 - get travel data at zone level
#
# allerton_bywater_oa_data = nomis_get_data(id = "NM_568_1", geography = c( "1254262620","1254262621","1254262622"), measures = "20100", rural_urban="0")
#
# allerton_bywater_oa_data = allerton_bywater_oa_data %>%
#   select(GEOGRAPHY, GEOGRAPHY_CODE, CELL, CELL_NAME, MEASURES, MEASURES_NAME, OBS_VALUE, OBS_STATUS, OBS_STATUS_NAME, OBS_CONF, OBS_CONF_NAME)


# Start here for the method used ------------------------------------------


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


geog_new_homes = c(allerton_bywater, chapelford, dickens_heath, newc_great_park, paxcroft, poundbury, upton, wichelstowe, wynyard, hamptons, wixams, stockmoor)

all_sites = list(allerton_bywater, chapelford, dickens_heath, newc_great_park, paxcroft, poundbury, upton, wichelstowe, wynyard, hamptons, wixams, stockmoor)


oa_data_all = nomis_get_data(id = "NM_568_1", geography = geog_new_homes, measures = "20100", rural_urban="0")

dim(oa_data_all)

oa_data_all = oa_data_all %>%
  select(GEOGRAPHY, GEOGRAPHY_CODE, GEOGRAPHY_TYPE, GEOGRAPHY_TYPECODE, CELL, CELL_NAME, MEASURES, MEASURES_NAME, OBS_VALUE, OBS_STATUS, OBS_STATUS_NAME, OBS_CONF, OBS_CONF_NAME) %>%
  inner_join(oas, by = c("GEOGRAPHY" = "geo_code"))
oa_data_all = st_as_sf(oa_data_all)

dim(oa_data_all)

# Create site variable identifying which site the row belongs to
library(data.table)
LDT = rbindlist(lapply(all_sites, data.table), idcol = TRUE)
oa_data_all = inner_join(oa_data_all,LDT, by = c("GEOGRAPHY" = "V1")) %>%
  rename(site = .id)


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
oa_level_data = inner_join(joined, lsoas_centroids, by = c("code" = "geo_code"))

# Get the list of LSOA geo_codes being used
geo_codes_used = unique(oa_level_data$code)


write_sf(oa_level_data, "oa-level-data.geojson")
piggyback::pb_upload("oa-level-data.geojson")

piggyback::pb_download_url("oa-level-data.geojson")
oa_level_data = read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/oa-level-data.geojson")

# Group OA level data by LSOA

oa_data_grouped_walk = oa_level_data %>%
  filter(CELL == 10) %>%
  group_by(code) %>%
  summarise(
    obs_value = sum(OBS_VALUE)
  ) %>%
  st_drop_geometry()

oa_data_grouped_cycle = oa_level_data %>%
  filter(CELL == 9) %>%
  group_by(code) %>%
  summarise(
    obs_value = sum(OBS_VALUE)
  ) %>%
  st_drop_geometry()

oa_data_grouped_all = oa_level_data %>%
  filter(CELL == 0) %>%
  group_by(code) %>%
  summarise(
    obs_value = sum(OBS_VALUE)
  )

oa_data_grouped_home = oa_level_data %>%
  filter(CELL == 1) %>%
  group_by(code) %>%
  summarise(
    obs_value = sum(OBS_VALUE)
  ) %>%
  st_drop_geometry()

oa_data_grouped_unempl = oa_level_data %>%
  filter(CELL == 12) %>%
  group_by(code) %>%
  summarise(
    obs_value = sum(OBS_VALUE)
  ) %>%
  st_drop_geometry()

oa_data_grouped_commuters = inner_join(oa_data_grouped_all,oa_data_grouped_home, by = "code") %>%
  rename(all = obs_value.x, home = obs_value.y) %>%
  inner_join(oa_data_grouped_unempl, by = "code") %>%
  rename(unemployed = obs_value) %>%
  mutate(commuters = all - home - unemployed) %>%
  select(code,commuters)

oa_data_grouped = inner_join(oa_data_grouped_cycle, oa_data_grouped_walk, by = "code") %>%
  rename(cycle = obs_value.x, walk = obs_value.y) %>%
  inner_join(oa_data_grouped_commuters, by = "code")

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

write_sf(lines_all, "lines-all.geojson")
piggyback::pb_upload("lines-all.geojson")

piggyback::pb_download_url("lines-all.geojson")
lines_all = read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/lines-all.geojson")

##

# Where geo_code1 is in the site
lines_1 = lines_all %>%
  select(geo_code1, geo_code2, all, bicycle, foot, car_driver
         # dutch_slc etc
  ) %>%
  filter(geo_code1 %in% geo_codes_used) %>%
  st_drop_geometry()

dim(lines_1)

# Where geo_code2 is in the site
`%notin%` <- Negate(`%in%`)

lines_2 = lines_all %>%
  select(geo_code1, geo_code2, all, bicycle, foot, car_driver
         # dutch_slc etc
  ) %>%
  filter(geo_code2 %in% geo_codes_used & geo_code1 %notin% geo_codes_used) %>%
  rename(geo_code1 = geo_code2, geo_code2 = geo_code1) %>%
  st_drop_geometry()

dim(lines_2)

lines_both = rbind(lines_1, lines_2)

dim(lines_both)

# Adding in the site ID
site_id = oa_level_data %>%
  select(c(code, site)) %>%
  unique()

lines_both = inner_join(lines_both,site_id, by = c("geo_code1" = "code"))


# Get OA centroids marking the middle of each new homes site --------------

# Group data by OA
oa_sites = oa_level_data %>%
  select(GEOGRAPHY, site, code) %>%
  group_by(GEOGRAPHY)
oa_sites = unique(oa_sites)
dim(oa_sites)

# Should really get the population weighted centroid for each OA, and then find the centre of the cluster of points to represent the whole site, but I haven't found an R function that picks the centre of a cluster of points yet
# http://geoportal.statistics.gov.uk/datasets/output-areas-december-2011-population-weighted-centroids
# toa = oa_sites[oa_sites$site==9,] %>%
#   st_transform(27700)
# tc = st_centroid(toa$geometry)
# mapview(tc)

# Pick the OA centroids that are closest to the centre of each site
chosen_oas = c("E00061995", "E00175567", "E00170565", "E00173169", "E00169240", "E00168166", "E00173784", "E00171320", "E00166484", "E00163618", "E00165967", "E00166084")

pickme = filter(oa_sites, GEOGRAPHY %in% chosen_oas)

mapview(pickme)

pickme_centroids = pickme %>%
  st_drop_geometry()
pickme_centroids = inner_join(oas_centroids, pickme_centroids, by = c("geo_code" = "GEOGRAPHY"))
dim(pickme_centroids)
mapview(pickme_centroids)

## Adding origin geo_codes from pickme_centroids
lines_both_oac = lines_both %>% inner_join(pickme_centroids, by = "site") %>%
  select(geo_code, geo_code2, all, bicycle, foot, site)

destinations = lines_both[,2] %>%
  inner_join(lsoas_centroids, by = c("geo_code2" = "geo_code")) # this misses destinations that are in a different PCT region. Perhaps I could extract the geometry data from lines_both to avoid this problem
destinations = st_as_sf(as.data.frame(destinations))

# I need to remove the lines where the destination is in a different PCT region, because these are messing up the od2line() function
dim(lines_both_oac)
lines_both_oac = lines_both_oac %>%
  filter(geo_code2 %in% destinations$geo_code2)
dim(lines_both_oac)



lines_correct_origin = stplanr::od2line(flow = lines_both_oac, # for the od data
                                    zones = pickme_centroids, # for the origin geometry
                                    destinations = destinations # for the destination geometry
                                        )

mapview(lines_correct_origin)

write_sf(lines_correct_origin, "lines-correct-origin.geojson")
piggyback::pb_upload("lines-correct-origin.geojson")


###

plot(lines_to_sites)
mapview::mapview(lines_to_sites)

#mapview(lines_both)

write_sf(lines_both, "lines-all-sites.geojson")
piggyback::pb_upload("lines-all-sites.geojson")

piggyback::pb_download_url("lines-all-sites.geojson")
lines_both = read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/lines-all-sites.geojson")

####Replace the geometry with more appropriate OA centroids (one for each LSOA or site) so the routing is done from the right places. I can copy the methods from leeds_routes.R for this.
###And join with oa_data_grouped and replace `all` `bicycle` `foot` with appropriate proportions

##grouping the LSOA data for totals for travel to work by foot, bicycle, all, so I can know how much to reduce them by proportionally.
# lsoa_data_grouped = lines_correct_origin %>%
#   group_by(geo_code1, site) %>%
#   summarise(
#     all = sum(all),
#     bicycle = sum(bicycle),
#     foot = sum(foot)
#   ) %>%
#   st_drop_geometry()
#
# ##
#
# both_grouped = lsoa_data_grouped %>%
#   inner_join(oa_data_grouped, by = c("geo_code1" = "code"))


#reducing totals proportionally by the number of OAs being used

oacodes = NULL
listcodes = NULL
for(i in 1:length(geo_codes_used)) {
  ladcode = geo_codes_used[i]
  oacodes = getsubgeographies(ladcode, "OA11")
  listcodes[i] = list(oacodes)
    }
oacodes
listcodes

listed = data.frame(geo_codes_used)
listed$listcodes <- sapply(listcodes, paste0, collapse=",")


joined2 %>% group_by()

listed$all_sites = sapply(all_sites, paste0, collapse=",") # this doesn't work because they are organised by site, not by LSOA

listed



# Join the list
cbind(lsoa_data_grouped,listcodes)

# Convert the lines into routes-------------------------------------------------

remotes::install_github("ropensci/stplanr", "par")
library(cyclestreets)
library(parallel)
library(stplanr)
cl = makeCluster(detectCores())
clusterExport(cl, c("journey"))
routes_to_site = route(l = lines_correct_origin, route_fun = cyclestreets::journey
                       , cl = cl  # this only works with the "par" version of stplanr
                       )

mapview(routes_to_site)


routes_to_site$busyness = routes_to_site$busynance / routes_to_site$distances
routes_to_site = routes_to_site %>% mutate(speed=distances/time)

write_sf(routes_to_site, "routes-all-sites.geojson")
piggyback::pb_upload("routes-all-sites.geojson")

routes_to_site = sf::read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/routes-all-sites.geojson")


## Create route network

r_grouped_census = routes_to_site %>%
  group_by(geo_code1, geo_code2) %>%
  summarise(
    n = n(), # is this the number of route segments each route contains?
    all = mean(all),
    average_incline = sum(abs(diff(elevations))) / sum(distances),
    distance_m = sum(distances),
    busyness = mean(busyness) %>%
  )

# summary(r_grouped)

# r_grouped_census$go_dutch = pct::uptake_pct_godutch(distance = r_grouped_census$distance_m, gradient = r_grouped_census$average_incline) *
  # r_grouped_census$all
r_grouped_census$govtarget = pct::uptake_pct_govtarget(distance = r_grouped_census$distance_m, gradient = r_grouped_census$average_incline) *
  r_grouped_census$all
# join-on data from census to get % cycling and % walking for each OD pair (route)
names(lines_correct_origin)
nrow(lines_correct_origin)
nrow(r_grouped_census)
mapview::mapview(sf::st_geometry(lines_correct_origin)[33]) +
  mapview::mapview(sf::st_geometry(r_grouped_census)[33])

r_grouped_census_joined = inner_join(r_grouped_census, sf::st_drop_geometry(lines_correct_origin))
r_grouped_census_joined$pcycle = r_grouped_census_joined$bicycle / r_grouped_census_joined$all

# train a model to discover parameters associated with business

# trying to replicate PCT model in GLM - not picking up logit link...
# I think the glm picks up the logit link fine
m_cycling = glm(pcycle ~
                  distance_m + # d1
                  sqrt(distance_m)  +  # d2
                  distance_m^2 + # d3
                  average_incline +    # h1
                  distance_m * average_incline +  # i1
                  sqrt(distance_m) * average_incline, # i2
                data = sf::st_drop_geometry(r_grouped_census_joined),
                family = quasibinomial(),
                weights = all
                  )
r_grouped_census_joined$pcycle[r_grouped_census_joined$pcycle < 0.001] = 0.001
# boot::logit(0)
# model 2: reproducing pct result on logit of pcycle
# m_cycling3 = lm(boot::logit(pcycle) ~
#                   distance_m + # d1
#                   sqrt(distance_m)  +  # d2
#                   distance_m^2 + # d3
#                   average_incline +    # h1
#                   distance_m * average_incline +  # i1
#                   sqrt(distance_m) * average_incline, # i2
#                 data = sf::st_drop_geometry(r_grouped_census_joined),
#                weights = all
#                )

# model 3: reproducing pct model with busyness
m_cycling2 = glm(pcycle ~
                 distance_m + # d1
                 sqrt(distance_m)  +  # d2
                 distance_m^2 + # d3
                 average_incline +    # h1
                 distance_m * average_incline +  # i1
                 sqrt(distance_m) * average_incline + # i2
                 busyness,
               data = sf::st_drop_geometry(r_grouped_census_joined),
               family = quasibinomial(),
               weights = all
)
# model 3: reproducing pct model with busyness
m_cycling4 = glm(pcycle ~
                 distance_m + # d1
                 sqrt(distance_m)  +  # d2
                 average_incline +    # h1
                 distance_m * average_incline +  # i1
                 busyness,
               data = sf::st_drop_geometry(r_grouped_census_joined),
               family = quasibinomial(),
               weights = all
)
fitted.values = m_cycling$fitted.values # for glm
# fitted.values = boot::inv.logit(m_cycling$fitted.values)

summary(m_cycling)

plot(r_grouped_census_joined$distance_m, fitted.values)
plot(r_grouped_census_joined$average_incline, fitted.values)
cor(r_grouped_census_joined$pcycle, fitted.values)^2 # explains around 7% of variability
cor(r_grouped_census_joined$govtarget, fitted.values)^2 # explains around 22% of PCT base scenario
plot(r_grouped_census_joined$govtarget / 100, fitted.values)^2

r_grouped_lines_census = r_grouped_census %>% st_cast("LINESTRING")
rnet_go_dutch_census = overline2(r_grouped_lines_census, "go_dutch")

# routes_to_site_census = routes_to_site
rnet_all_census = overline2(routes_to_site, "all")

write_sf(rnet_all_census, "rnet-all-census.geojson")
piggyback::pb_upload("rnet-all-census.geojson")

piggyback::pb_download_url("rnet-all-census.geojson")
rnet_all_census = read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/rnet-all-census.geojson")

## Make busyness map

##I need the maps to be weighted by the OA data on number of commuters (as the stats already are) In STARS a similar re-splitting of lines was done. Check this.


library(tmap)
tmap_mode("view")

tm_shape(rnet_go_dutch_census) +
  tm_lines("go_dutch", lwd = "go_dutch", scale = 9, palette = "plasma", breaks = c(0, 10, 50, 100, 200))

tm_shape(rnet_all_census) +
  tm_lines("all", lwd = "all", scale = 9, palette = "plasma", breaks = c(0, 10, 50, 100, 200))

tm_shape(rnet_all_census) +
  tm_lines("all", lwd = "all", scale = 9, palette = "plasma", breaks = c(0, 10, 50, 100, 200))


##Group route segments by destination

r_whole_routes = routes_to_site %>%
  group_by(geo_code1, geo_code2, site) %>%
  summarise(
    all = mean(all),
    average_incline = sum(abs(diff(elevations))) / sum(distances),
    distance_km = sum(distances)/1000,
    mean_busyness = weighted.mean(busyness,distances),
    max_busyness = max(busyness),
    time_mins = sum(time)/60
  ) %>%
  ungroup()

r_whole_routes = r_whole_routes %>%
  mutate(speed_mph = (distance_km*1000)/(time_mins*60)*2.237)


##Get mean metrics for each LSOA
# these are weighted by the number of commuters on each route

r_whole_weighted = r_whole_routes %>%
  group_by(geo_code1, site) %>%
  st_drop_geometry() %>%
  summarise(mean_speed = weighted.mean(speed_mph,all),
            mean_distance = weighted.mean(distance_km,all),
            mean_busyness = weighted.mean(mean_busyness,all),
            max_busyness = weighted.mean(max_busyness,all))
r_whole_weighted

##Join OA and LSOA data

oa_data_no_geo = oa_data_grouped %>%
  st_drop_geometry()
full_dataset_by_lsoa = inner_join(r_whole_weighted,oa_data_no_geo, by = c("geo_code1" = "code")) %>%
  mutate(perc_cycle = cycle/commuters, perc_walk = walk/commuters)

##weight by the number of commuters in OAs within each LSOA (eg avoid Wynyard being dominated by Hartlepool)

full_dataset_by_site = full_dataset_by_lsoa %>%
  group_by(site) %>%
  summarise(
    mean_speed = weighted.mean(mean_speed, commuters),
    mean_distance = weighted.mean(mean_distance, commuters),
    mean_busyness = weighted.mean(mean_busyness, commuters),
    max_busyness = weighted.mean(max_busyness, commuters),
    perc_cycle = weighted.mean(perc_cycle, commuters),
    perc_walk = weighted.mean(perc_walk, commuters)
  )

full_dataset_by_site


summary(r_whole_routes[r_whole_routes$site == 1,])



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
