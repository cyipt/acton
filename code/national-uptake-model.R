# Aim: model national data on cycling uptake, with newness of development as an explanatory variable

library(tidyverse)

property_age_lsoa = read_rds("property-age-lsoa.Rds")
dim(property_age_lsoa)

over_80pc = property_age_lsoa %>%
  filter(p2000_09 > 0.8)
dim(over_80pc)

over_60pc = property_age_lsoa %>%
  filter(p2000_09 > 0.6)
dim(over_60pc)

new_homes_2000_09 = property_age_lsoa %>%
  filter(p2000_09 > 0.9)
new_homes_2000_09$id = seq.int(nrow(new_homes_2000_09))
dim(new_homes_2000_09)
View(new_homes_2000_09)


u = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/England_lsoa_2011_clipped.zip"
u2 = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/Wales_lsoa_2011_clipped.zip"

lsoas_eng = ukboundaries::duraz(u = u)
lsoas_wales = ukboundaries::duraz(u = u2)
lsoas = rbind(lsoas_eng,lsoas_wales)

new_homes_2000_09 = new_homes_2000_09 %>%
  inner_join(lsoas, by = c("lsoa" = "code")) %>%
  st_as_sf()

mapview::mapview(new_homes_2000_09)

# Remove 20% of records for model validation
n_excluded = round(nrow(new_homes_2000_09)*0.2)
excluded = new_homes_2000_09[sample(nrow(new_homes_2000_09),n_excluded),]
`%notin%` = Negate(`%in%`)
included = new_homes_2000_09[new_homes_2000_09$id %notin% excluded$id,]
dim(included)

# Get OD data for all sites

# First, find out which PCT region sites are in
new_homes_2000_09$region = substr(new_homes_2000_09$Name, 1, nchar(new_homes_2000_09$Name)-5)
new_homes_2000_09 = inner_join(new_homes_2000_09, pct_regions_lookup, by = c("region" = "lad16nm"))
dim(new_homes_2000_09)

View(new_homes_2000_09)

# How do we quickly get OD data for all these regions?

