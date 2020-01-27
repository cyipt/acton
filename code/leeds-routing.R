# get route data associated with a development - reproducible

library(dplyr)
library(stplanr)

# make data available
# sites = readRDS("~/NewDevelopmentsCycling/data/leeds-sites.Rds")
# sf::write_sf(sites, "sites-leeds.geojson")
# piggyback::pb_upload("sites-leeds.geojson")

# get sites data
# piggyback::pb_download_url("sites-leeds.geojson")
sites = sf::read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/sites-leeds.geojson")
# identify centroid closest to

od_all_en_wales = pct::get_od()

# Create desire lines from development site to common destinations from nearest centroid

c = pct::get_pct_centroids(region = "west-yorkshire", geography = "lsoa") %>% rename(LA_Code = lad11cd)
m = pct::get_pct_centroids(region = "west-yorkshire", geography = "msoa") %>% rename(LA_Code = lad11cd)
lines_pct_lsoa = pct::get_pct_lines(region = "west-yorkshire", geography = "lsoa")
lines_pct_msoa = pct::get_pct_lines(region = "west-yorkshire", geography = "msoa")

centroids_nearest_site = sites$msoa_code
#uses MSOA codes
od_from_centroids_near_sites = od_all_en_wales %>%
  filter(geo_code1 %in% centroids_nearest_site)

od_from_centroids_near_sites = lines_pct_msoa %>%
  select(geo_code1, geo_code2, all, bicycle, car_driver, car_passenger
         # bus, taxi etc
         ) %>%
  filter(geo_code1 %in% centroids_nearest_site, geo_code2 %in% m$geo_code) %>%
  sf::st_drop_geometry()

# # add on the site_id (first column)
sites_column_name_updated = sites %>%
  select(msoa_code, geo_code, everything())

lines_to_sites = stplanr::od2line(od_from_centroids_near_sites, sites_column_name_updated, m)
plot(lines_to_sites)
mapview::mapview(lines_to_sites)

library(parallel)
cl <- makeCluster(detectCores())
clusterExport(cl, c("journey"))
routes_to_site = route(l = lines_to_sites, route_fun = cyclestreets::journey, cl = cl)
routes_to_site_quietest = route(l = lines_to_sites, route_fun = cyclestreets::journey, cl = cl, plan = "quietest")
mapview::mapview(routes_to_site_quietest)
identical(routes_to_site, routes_to_site_quietest)
