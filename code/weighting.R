devtools::install_github("cyipt/acton")
#> Skipping install of 'acton' from a github remote, the SHA1 (6c4468f7) has not changed since last install.
#>   Use `force = TRUE` to force installation

library(acton)
library(dplyr)


jts = get_jts_data("jts0501", 2017)
jts$weighted_PTt = apply(
  X = jts[c("Jobs100EmpPTt", "Jobs500EmpPTt", "Jobs5000EmpPTt")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)
jts$weighted_Cyct = apply(
  X = jts[c("Jobs100EmpCyct", "Jobs500EmpCyct", "Jobs5000EmpCyct")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)
jts$weighted_Cart = apply(
  X = jts[c("Jobs100EmpCart", "Jobs500EmpCart", "Jobs5000EmpCart")],
  MARGIN = 1,
  FUN = weighted.mean,
  w = c(100, 500, 5000)
)

zones_leeds = sf::read_sf("https://github.com/cyipt/acton/releases/download/0.0.1/zones_leeds_pct_jts_2017_lsoa.geojson")

# zones_leeds$weighted_mean_time_to_employment_centre = apply(
#   X = zones_leeds[c("Jobs100EmpPTt", "Jobs500EmpPTt", "Jobs5000EmpPTt")],
#   MARGIN = 1,
#   FUN = weighted.mean,
#   w = c(100, 500, 5000)
# )


zz = left_join(zones_leeds,jts, "geo_code" = "LSOA_code")


library(tmap)
tmap_mode("plot")


qtm(zz,"weighted_PTt")
qtm(zz, c("weighted_PTt", "weighted_Cyct", "weighted_Cart")) +
  tm_facets(nrow = 1)

qtm(zz, c("Jobs5000EmpPTt", "Jobs5000EmpCyct", "Jobs5000EmpCart")) +
  tm_facets(nrow = 1)

qtm(zz, c("Jobs5000EmpPTt", "Jobs5000EmpCyct", "Jobs5000EmpCart")) +
  tm_facets(nrow = 1)

