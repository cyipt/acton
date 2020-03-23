# Get developments built between 2000 and 2011

library(pct)
library(dplyr)


abz = get_pct_zones(region = "west-yorkshire", geography = "lsoa")

mapview::mapview(abz)

# LSOAs are too large. There are none that cover the Millennium Community only. These two are in the old village.
abz = abz %>%
  filter(geo_code == "E01011308" | geo_code == "E01011307")

# hello robin
# hello joey

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

# get travel data at OA level
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
dickens_heath = c("E01032885", "E00168171", "E00168172", "E00168175", "E00168173", "E00168177", "E00168176", "E00168178", "E00168174", "E00051490")
newc_great_park = c("E01033550", "E00175591", "E00175572", "E00042147")
paxcroft = c("E00166462", "E00166415", "E00166413", "E00163729", "E00166403", "E00166406", "E00166338", "E00163618", "E00163617")
poundbury = c("E01032641", "E00166086", "E00166084", "E00104084")
upton = c("E00169237", "E00169240", "E00169239", "E00169242")
wichelstowe = c("E00166484", "E00166486", "E00166485")
wynyard = c("E01033476", "E00174185", "E00060314")

geog_new_homes = c(allerton_bywater, chapelford, dickens_heath, newc_great_park, paxcroft, poundbury, upton, wichelstowe, wynyard)

oa_data_all = nomis_get_data(id = "NM_568_1", geography = geog_new_homes, measures = "20100", rural_urban="0")

oa_data_all = oa_data_all %>%
  select(GEOGRAPHY, GEOGRAPHY_CODE, GEOGRAPHY_TYPE, GEOGRAPHY_TYPECODE, CELL, CELL_NAME, MEASURES, MEASURES_NAME, OBS_VALUE, OBS_STATUS, OBS_STATUS_NAME, OBS_CONF, OBS_CONF_NAME)

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
