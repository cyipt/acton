# Get developments built between 2000 and 2011

library(pct)
library(dplyr)


abz = get_pct_zones(region = "west-yorkshire", geography = "lsoa")

mapview::mapview(abz)

# LSOAs are too large. There are none that cover the Millennium Community only. These two are in the old village.
abz = abz %>%
  filter(geo_code == "E01011308" | geo_code == "E01011307")
