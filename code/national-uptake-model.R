# Aim: model national data on cycling uptake, with newness of development as an explanatory variable

library(tidyverse)

property_age_lsoa = read_rds("property-age-lsoa.Rds")
dim(property_age_lsoa)


# Find LSOAs with high proportions of new homes
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

summary(centroids_lsoa$all) # this records intrazonal commutes only

u3 = "https://github.com/npct/pct-outputs-national/raw/master/commute/lsoa/z_all.Rds"
zones_lsoa_national_sp = readRDS(url(u3))
zones_lsoa = sf::st_as_sf(zones_lsoa_national_sp)
names(zones_lsoa)
nrow(zones_lsoa)
nrow(lsoas)

summary(zones_lsoa$all)

object.size(zones_lsoa) / object.size(lsoas)

# Why do many of these LSOAs have such low commuter totals??
pct_lsoa_selected_variables = centroids_lsoa %>%
  dplyr::select(geo_code, all:taxi_other, govtarget_slc, dutch_slc, lad_name)

lsoas = inner_join(pct_lsoa_selected_variables, property_age_lsoa, by = c("geo_code" = "lsoa"))
library(sf)
plot(lsoas %>% filter(lad_name == "Leeds"))
plot(lsoas %>% filter(lad_name == "Leeds") %>% select(Pre_1900:p2000_09))
plot(lsoas %>% filter(lad_name == "Leeds") %>% select(p2000_09))



# National LSOA OD data ---------------------------------------------------


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
  select(geocode1 = "Area of usual residence", geocode2 = "Area of Workplace", matches("AllSexes_Age16Plus"))
names(od_lsoa) = gsub(pattern = "AllSexes_Age16Plus|_", "", names(od_lsoa))
summary(rowSums(od_lsoa %>% select(WorkAtHome:OtherMethod)) == od_lsoa$AllMethods)
# od_lsoa$AllMethods = NULL

remotes::install_github("itsleeds/od") # open issue on od package. It allows lines with NA coordinates. 2 - it doesnt copy crs system
library(od)

od_lsoa_sf = od_to_sf(od_lsoa, z = centroids_lsoa) # 433331 rows
sf::st_crs(centroids_lsoa)
sf::st_crs(od_lsoa_sf) = 4326

od_lsoas_sf_interzonal = od_lsoa_sf %>%
  filter(geocode1 != geocode2) # 410559 rows

od_lsoas_sf_interzonal = od_lsoas_sf_interzonal %>%
  filter(geocode1 %in% centroids_lsoa$geo_code) # still the same

od_lsoas_sf_interzonal = od_lsoas_sf_interzonal %>%
  filter(geocode2 %in% centroids_lsoa$geo_code) # 340595 rows

sum(od_lsoas_sf_interzonal$AllMethods) / sum(od_lsoa_sf$AllMethods) # 56% remain

od_lsoas_sf_interzonal$distance_euclidean = as.numeric(sf::st_length(od_lsoas_sf_interzonal))
summary(od_lsoas_sf_interzonal$distance)

# Divide into lines over and under 20km
od_lsoas_short = od_lsoas_sf_interzonal %>%
  filter(distance_euclidean < 20000)

od_lsoas_long = od_lsoas_sf_interzonal %>%
  filter(distance_euclidean >= 20000)

saveRDS(od_lsoas_short, "od_lsoas_short.Rds")
saveRDS(od_lsoas_long, "od_lsoas_long.Rds")

# routing script ----------------------------------------------------------

od_lsoas_short = readRDS("od_lsoas_short.Rds")
dim(od_lsoas_short) # 330567 rows
remotes::install_github("ropensci/stplanr")

library(sf)
library(stplanr)
library(parallel)
library(cyclestreets)
cl = makeCluster(detectCores())
clusterExport(cl, c("journey"))
# test run:
l_test = od_lsoas_short[1:100,]
routes_lsoa = stplanr::route(l_test, route_fun = cyclestreets::journey, cl = cl)
names(routes_lsoa) # df variables have been lost
routes_lsoa = stplanr::route(l = l_test, route_fun = cyclestreets::journey, cl = cl)
names(routes_lsoa) # df variables have been lost

N = 1000
# split_grouping_variable = cut(1:nrow(od_lsoas_short), breaks = N, labels = 1:N)
split_grouping_variable = rep(1:34000, each = 1000)[1:nrow(od_lsoas_short)]
summary(split_grouping_variable)[1:10]
od_lsoas_short_list = split(od_lsoas_short, split_grouping_variable)
class(od_lsoas_short_list)
length(od_lsoas_short_list)
nrow(od_lsoas_short_list[[1]])
head(od_lsoas_short_list[[1]])
# test it's the same
identical(od_lsoas_short[1:1000,], od_lsoas_short_list[[1]])

system.time({routes_lsoa_1 = route(od_lsoas_short_list[[1]], route_fun = cyclestreets::journey, cl = cl)})
# 70 seconds, implying ~ 20 hrs for all routes

data_dir = "od_lsoa_routes_20020-04-07-chunks-of-1000-rows"
dir.create(data_dir)
old_working_directory = setwd(data_dir)
n_chunks = length(od_lsoas_short_list)
# started at 23:05
for(i in 1:n_chunks) {
  message("Routing batch ", i, " of ", n_chunks)
  system.time({routes_lsoa_n = route(l = od_lsoas_short_list[[i]], route_fun = cyclestreets::journey, cl = cl)})
  saveRDS(routes_lsoa_n, paste0("routes_lsoa_", i, ".Rds"))
}
route_chunks_list = lapply(1:n_chunks, {
  function(i) readRDS(paste0("routes_lsoa_", i, ".Rds"))
}
)
length(route_chunks_list)
length(route_chunks_list[1:33])
system.time({od_lsoas_short_routes = do.call(rbind, route_chunks_list[1:33])}) # time taken for 10%... ~2 minutes
system.time({od_lsoas_short_routes = data.table::rbindlist(route_chunks_list[1:33])}) # less than 1 second!
# Guess: it will take around 2*10 = 20 minutes
system.time({od_lsoas_short_routes = data.table::rbindlist(route_chunks_list)}) #

setwd(old_working_directory)

saveRDS(od_lsoas_short_routes, "od_lsoas_short_routes.Rds")
piggyback::pb_upload("od_lsoas_short_routes.Rds")


# analysis with route data ------------------------------------------------

od_lsoas_short_routes = readRDS(url("https://github.com/cyipt/acton/releases/download/0.0.1/od_lsoas_short_routes.Rds"))
nrow(od_lsoas_short_routes)
nrow(od_lsoas_short_routes) / nrow(od_lsoas_short)


# summarise with average steepness, median, 75% percentile, 90% percentile, 95th percentile, 99th percentile, 100th percent...



# join-on data from origins
stopCluster(cl)
# 69964 NA where geocode2 is a destination outside the country or other unusual place
View(od_lsoas_sf_interzonal[is.na(od_lsoas_sf_interzonal$distance_euclidean),])

od_lsoas_sf_interzonal = od_lsoas_sf_interzonal %>%
  filter(is)

plot(od_lsoa_sf[1:100,])

# library(pct)
# lsoas_reg = inner_join(lsoas, pct_regions_lookup, by = c("lad_name" = "lad16nm"))
# dim(lsoas_reg)
# summary(factor(lsoas_reg$region_name))
#
# View(lsoas_reg[is.na(lsoas_reg$region_name),])


# Join with centroids from PCT to get geometry --------------------------------------------
# this joins with the geometry of the origin
od_national = inner_join(od_lsoa, lsoas, by = c("geocode1" = "geo_code"))

# destination geometry



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


