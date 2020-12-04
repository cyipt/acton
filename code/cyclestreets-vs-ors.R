# comparison between cyclestreets and ORS data

library(tmap)
tmap_mode("view")
library(dplyr)
library(geofabrik)
devtools::install_github("ropensci/stplanr", "par")

remotes::install_github("itsleeds/od")

lines_leeds = pct::get_pct_lines("west-yorkshire")
lines = lines_leeds %>%
  filter(lad_name1 == "Leeds") %>%
  filter(lad_name2 == "Leeds") %>%
  top_n(n = 30, wt = all) %>%
  select(-id)

od = lines %>%
  sf::st_drop_geometry()

zones_region = pct::get_pct_zones("west-yorkshire")
zones = zones_region %>% filter(lad_name == "Leeds")
network_region = geofabrik::get_geofabrik(zones)
network = network_region[zones, ] %>%
  filter(stringr::str_detect(highway, "prim|sec|cycl|trunk|tert"))

# mapview::mapview(lines) + mapview::mapview(zones)
tm_shape(zones) + tm_borders(col = "red") +
  tm_shape(network) + tm_lines() +
  tm_shape(lines) + tm_lines(col = "green")

library(od)
library(cyclestreets)
lines_offcentre = od::od_to_sf_network(x = od, z = zones, network = network)

tm_shape(lines) + tm_lines("green") +
  tm_shape(lines_offcentre) + tm_lines("red") +
  tm_shape(zones) + tm_borders()

cl = parallel::makeCluster(4)
parallel::clusterExport(cl, "journey")
routes_cyclestreets = stplanr::route(
  l = lines,
  route_fun = journey,
  cl = cl,
  plan = "balanced"
  )

routes_cyclestreets_offset = stplanr::route(
  l = lines_offcentre,
  route_fun = journey,
  cl = cl,
  plan = "balanced"
)

rnet = stplanr::overline(routes_cyclestreets, "bicycle")
rnet_offset = stplanr::overline(routes_cyclestreets_offset, "bicycle")
tm_shape(rnet) + tm_lines("green", lwd = "bicycle", scale = 9) +
  tm_shape(rnet_offset) + tm_lines("red", lwd = "bicycle", scale = 3)


od_sf_top = lines
od_sf_top_o = sf::st_coordinates(lwgeom::st_startpoint(od_sf_top$geometry))
od_sf_top_d = sf::st_coordinates(lwgeom::st_endpoint(od_sf_top$geometry))
od_sf_top_coordinates = as.matrix(data.frame(
  od_sf_top_o,
  od_sf_top_d
))
head(od_sf_top_coordinates)
library(openrouteservice)
x = ors_directions(list(od_sf_top_o[1, ], od_sf_top_d[1, ]), output = "sf")
mapview::mapview(x)
x_list = pbapply::pblapply(X = 1:nrow(od_sf_top), FUN = function(i) {
  # message(i)
  ors_directions(list(od_sf_top_o[i, ], od_sf_top_d[i, ]), output = "sf")
})
x_ors_driving = do.call(rbind, x_list)
x_list = pbapply::pblapply(X = 1:nrow(od_sf_top), FUN = function(i) {
  # message(i)
  ors_directions(list(od_sf_top_o[i, ], od_sf_top_d[i, ]), output = "sf",
                 profile = "cycling-regular")
})
x_ors_cycling_regular = do.call(rbind, x_list)

mapview::mapview(x_list[[3]])
# tm_shape(x_ors_driving) + tm_lines("red") +
tm_shape(x_ors_cycling_regular) + tm_lines("red") +
  tm_shape(routes_cyclestreets) + tm_lines("green")

# tests

x = od_data_df
z = od_data_zones_min
network = od_data_network
(lines_to_points_on_network = od_to_sf_network(x, z, network = network))
(lines_to_points = od_to_sf(x, z))
# to put in vignette...
library(tmap)
tmap_mode("view")
tm_shape(lines_to_points_on_network) + tm_lines(lwd = 5) +
 tm_shape(lines_to_points) + tm_lines(col = "grey", lwd = 5) +
 tm_shape(od_data_zones_min) + tm_borders() +
 qtm(od_data_network, lines.col = "yellow")
plot(sf::st_geometry(lines_to_points_on_network))
plot(lines_to_points, col = "grey", add = TRUE)
plot(sf::st_geometry(z), add = TRUE)

rf = pct::get_pct_routes_fast("west-yorkshire")




