# Aim: get national data for uptake model work

library(tidyverse)
u = "https://data.london.gov.uk/download/property-build-period-lsoa/d022a431-1687-422e-ae53-fca9ec221c45/dwelling-period-built-2014-lsoa.csv"
property_age_data_full = read_csv(u )
# change col types:
coltypes = cols(
  lsoa = col_character(),
  GEOG = col_character(),
  Name = col_character(),
  Pre_1900 =    col_number(),
  `1900_1918` = col_number(),
  `1919_1929` = col_number(),
  `1930_1939` = col_number(),
  `1945_1954` = col_number(),
  `1955_1964` = col_number(),
  `1965_1972` = col_number(),
  `1973_1982` = col_number(),
  `1983_1992` = col_number(),
  `1993_1999` = col_number(),
  `2000_2009` = col_number(),
  `2010_2014` = col_number(),
      UNKNOWN = col_number()
)
property_age_data_full = read_csv(u, col_types = coltypes)
property_age_data_full
property_age_lsoa = property_age_data_full %>%
  filter(GEOG == "LSOA")
