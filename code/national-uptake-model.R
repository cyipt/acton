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
# View(new_homes_2000_09)


# Remove 20% of records for model validation
n_excluded = round(nrow(new_homes_2000_09)*0.2)
excluded = new_homes_2000_09[sample(nrow(new_homes_2000_09),n_excluded),]
included = new_homes_2000_09[! new_homes_2000_09$id %in% excluded$id,]
dim(included)

# Get OD data for all sites

# First, find out which PCT region sites are in
new_homes_2000_09$region = substr(new_homes_2000_09$Name, 1, nchar(new_homes_2000_09$Name)-5)
new_homes_2000_09 = inner_join(new_homes_2000_09, pct_regions_lookup, by = c("region" = "lad16nm"))
dim(new_homes_2000_09)
summary(factor(new_homes_2000_09$region))

# View(new_homes_2000_09)
plot(new_homes_2000_09 %>% filter(region == "Leeds"))
mapview::mapview(new_homes_2000_09 %>% filter(region == "Leeds"))

# add pct data ------------------------------------------------------------

u = "https://github.com/npct/pct-outputs-national/raw/master/commute/lsoa/l_all.Rds"
desire_lines_lsoa_national_sp = readRDS(url(u))
l = sf::st_as_sf(desire_lines_lsoa_national_sp)

u2 = "https://github.com/npct/pct-outputs-national/raw/master/commute/lsoa/c_all.Rds"
centroids_lsoa_national_sp = readRDS(url(u2))
centroids_lsoa = sf::st_as_sf(centroids_lsoa_national_sp)
names(centroids_lsoa)
nrow(centroids_lsoa)
nrow(lsoas)

u3 = "https://github.com/npct/pct-outputs-national/raw/master/commute/lsoa/z_all.Rds"
zones_lsoa_national_sp = readRDS(url(u3))
zones_lsoa = sf::st_as_sf(zones_lsoa_national_sp)
names(zones_lsoa)
nrow(zones_lsoa)
nrow(lsoas)

object.size(zones_lsoa) / object.size(lsoas)

pct_lsoa_selected_variables = zones_lsoa %>% 
  dplyr::select(geo_code, all:taxi_other, govtarget_slc, dutch_slc, lad_name) 

lsoas = inner_join(pct_lsoa_selected_variables, property_age_lsoa, by = c("geo_code" = "lsoa"))
library(sf)
plot(lsoas %>% filter(lad_name == "Leeds")) 
plot(lsoas %>% filter(lad_name == "Leeds") %>% select(Pre_1900:p2000_09)) 
plot(lsoas %>% filter(lad_name == "Leeds") %>% select(p2000_09)) 

#        commissioned dataset = WM12EW[CT0489]_lsoa ; save to 'pct-inputs\01_raw\02_travel_data\commute\lsoa\WM12EW[CT0489]_lsoa.zip'
# from PCT project

# unzip("~/cyipt/icicle/WM12EW[CT0489]_lsoa.zip", exdir = tempdir())
# list.files("/tmp/")
# # od_lsoa_wicid = read_csv(file = file.path(tempdir(), "WM12EW[CT0489]_lsoa.csv"))
# od_lsoa_wicid = vroom::vroom(file = file.path(tempdir(), "WM12EW[CT0489]_lsoa.csv"))
# summary(od_lsoa_wicid$AllMethods_AllSexes_Age16Plus)
# sum(od_lsoa_wicid$AllMethods_AllSexes_Age16Plus)
# od_lsoa_16_plus_10_plus = od_lsoa_wicid %>% filter(AllMethods_AllSexes_Age16Plus >= 10)
# nrow(od_lsoa_16_plus_10_plus) / nrow(od_lsoa_wicid)
# sum(od_lsoa_16_plus_10_plus$AllMethods_AllSexes_Age16Plus) / sum(od_lsoa_wicid$AllMethods_AllSexes_Age16Plus)
# saveRDS(od_lsoa_16_plus_10_plus, "od_lsoa_16_plus_10_plus.Rds")
# piggyback::pb_upload("od_lsoa_16_plus_10_plus.Rds", repo = "cyipt/icicle")
piggyback::pb_download("od_lsoa_16_plus_10_plus.Rds", repo = "cyipt/icicle")
od_lsoa_16_plus_10_plus = readRDS("od_lsoa_16_plus_10_plus.Rds")
od_lsoa = od_lsoa_16_plus_10_plus %>%
  select(matches("AllSexes_Age16Plus")) 
names(od_lsoa) = gsub(pattern = "AllSexes_Age16Plus|_", "", names(od_lsoa))
summary(rowSums(od_lsoa %>% select(WorkAtHome:OtherMethod)) == od_lsoa$AllMethods)
# od_lsoa$AllMethods = NULL

# get LSOA OD data

# subset the files of interest
lsoa_line_aggregated = l %>% 
  group_by()


# get high res data -------------------------------------------------------
# 
# u = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/England_lsoa_2011_clipped.zip"
# u2 = "https://borders.ukdataservice.ac.uk/ukborders/easy_download/prebuilt/shape/Wales_lsoa_2011_clipped.zip"
# 
# lsoas_eng = ukboundaries::duraz(u = u)
# lsoas_wales = ukboundaries::duraz(u = u2)
# lsoas = rbind(lsoas_eng,lsoas_wales)
# 
# new_homes_2000_09 = new_homes_2000_09 %>%
#   inner_join(lsoas, ., by = c("code" = "lsoa")) 
# 
# class(new_homes_2000_09)
# summary(new_homes_2000_09)
# plot(new_homes_2000_09[1, ])
# mapview::mapview(new_homes_2000_09[1:1000, ])


