# prep acessability
library(readxl)
library(readODS)

dir.create("Z:/data/tmp")
unzip("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/jts0504-to-jts0508.zip", exdir = "Z:/data/tmp")
unzip("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/jts0501-to-jts0503.zip", exdir = "Z:/data/tmp")

#town centre
access_town <- readxl::read_excel("Z:/data/tmp/jts0508.xlsx")
# access_town <- readODS::read_ods("Z:/data/tmp/jts0508.ods", sheet = 2, skip = 6)
access_town <- as.data.frame(access_town)
# names(access_town) <- access_town[6,]
# access_town <- access_town[7:nrow(access_town),]
# access_town <- access_town[!is.na(access_town$LA_Code),]
# access_town[6:ncol(access_town)] <- lapply(access_town[6:ncol(access_town)], as.numeric)

access_town = access_town[,c("LSOA_code",
                             "LA_Code",
                             "TownPTt",
                             "TownCyct",
                             "TownCart",
                             "TownPT15pct",
                             "TownCyc15pct",
                             "TownCar15pct",
                             "TownPT30pct",
                             "TownCyc30pct",
                             "TownCar30pct")]

saveRDS(access_town, "../NewDevelopmentsCycling/data/accessibility/access_town.Rds")

#employment
access_employ <- readxl::read_excel("Z:/data/tmp/jts0501.xlsx")
access_employ <- as.data.frame(access_employ)

access_employ = access_employ[,c("LSOA_code",
                                 "LA_Code",
                                 "100EmpPTt",
                                 "100EmpCyct",
                                 "100EmpCart",
                                 "500EmpPTt",
                                 "500EmpCyct",
                                 "500EmpCart",
                                 "5000EmpPTt",
                                 "5000EmpCyct",
                                 "5000EmpCart",
                                 "100EmpPT15pct",
                                 "100EmpCyc15pct",
                                 "100EmpCar15pct",
                                 "100EmpPT30pct",
                                 "100EmpCyc30pct",
                                 "100EmpCar30pct",
                                 "500EmpPT15pct",
                                 "500EmpCyc15pct",
                                 "500EmpCar15pct",
                                 "500EmpPT30pct",
                                 "500EmpCyc30pct",
                                 "500EmpCar30pct",
                                 "5000EmpPT15pct",
                                 "5000EmpCyc15pct",
                                 "5000EmpCar15pct",
                                 "5000EmpPT30pct",
                                 "5000EmpCyc30pct",
                                 "5000EmpCar30pct")]


saveRDS(access_employ, "../NewDevelopmentsCycling/data/accessibility/access_employ.Rds")

#food
access_food <- readxl::read_excel("Z:/data/tmp/jts0507.xlsx")
access_food <- as.data.frame(access_food)

access_food = access_food[,c("LSOA_code",
                             "LA_Code",
                             "FoodPTt",
                             "FoodCyct",
                             "FoodCart",
                             "FoodPT15pct",
                             "FoodCyc15pct",
                             "FoodCar15pct",
                             "FoodPT30pct",
                             "FoodCyc30pct",
                             "FoodCar30pct")]


saveRDS(access_food, "../NewDevelopmentsCycling/data/accessibility/access_food.Rds")


#GP
access_gp <- readxl::read_excel("Z:/data/tmp/jts0505.xlsx")
access_gp <- as.data.frame(access_gp)

access_gp = access_gp[,c("LSOA_code",
                         "LA_Code",
                         "GPPTt",
                         "GPCyct",
                         "GPCart",
                         "GPPT15pct",
                         "GPCyc15pct",
                         "GPCar15pct",
                         "GPPT30pct",
                         "GPCyc30pct",
                         "GPCar30pct")]


saveRDS(access_gp, "../NewDevelopmentsCycling/data/accessibility/access_gp.Rds")


#primary
access_primary <- readxl::read_excel("Z:/data/tmp/jts0502.xlsx")
access_primary <- as.data.frame(access_primary)

access_primary = access_primary[,c("LSOA_code",
                                   "LA_Code",
                                   "PSPTt",
                                   "PSCyct",
                                   "PSCart",
                                   "PSPT15pct",
                                   "PSCyc15pct",
                                   "PSCar15pct",
                                   "PSPT30pct",
                                   "PSCyc30pct",
                                   "PSCar30pct")]


saveRDS(access_primary, "../NewDevelopmentsCycling/data/accessibility/access_primary.Rds")


#secondary
access_secondary <- readxl::read_excel("Z:/data/tmp/jts0503.xlsx")
access_secondary <- as.data.frame(access_secondary)

access_secondary = access_secondary[,c("LSOA_code",
                                       "LA_Code",
                                       "SSPTt",
                                       "SSCyct",
                                       "SSCart",
                                       "SSPT15pct",
                                       "SSCyc15pct",
                                       "SSCar15pct",
                                       "SSPT30pct",
                                       "SSCyc30pct",
                                       "SSCar30pct")]


saveRDS(access_secondary, "../NewDevelopmentsCycling/data/accessibility/access_secondary.Rds")

# unlink("tmp", recursive = TRUE)


# upload csv files --------------------------------------------------------

list.files("Z:/data/tmp/")
excel_files = list.files("Z:/data/tmp/", pattern = "xl", full.names = TRUE)

i = 1
for(i in 1:length(excel_files)) {
  base_name = basename(excel_files[i])
  csv_name = gsub(pattern = ".xlsx", replacement = ".csv", x = base_name)
  d = readxl::read_excel(excel_files[i])
  names(d)
  head(d)
  readr::write_csv(d, csv_name)
  piggyback::pb_upload(csv_name)
}
