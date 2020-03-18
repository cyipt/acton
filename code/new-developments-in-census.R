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

# get travel data at OA level
# there are two approaches:
# 1  start with zone data
# 2  start with OD data and aggregate

# 1 - get travel data at zone level



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
