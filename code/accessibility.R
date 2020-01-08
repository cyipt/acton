# prep acessability

#town
dir.create("tmp")
unzip("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/jts0504-to-jts0508.zip", exdir = "tmp")
access_town <- readxl::read_excel("Z:/data/jts0508.xlsx", col_names = TRUE)
access_town <- as.data.frame(access_town)
# names(access_town) <- access_town[6,]
# access_town <- access_town[7:nrow(access_town),]
access_town <- access_town[!is.na(access_town$`LA Code`),]
# access_town[6:ncol(access_town)] <- lapply(access_town[6:ncol(access_town)], as.numeric)

access_town = access_town[,c("LSOA_code",
                             "TownPTt",
                             "TownCyct",
                             "TownCart",
                             "TownPT15pct",
                             "TownCyc15pct",
                             "TownCar15pct",
                             "TownPT30pct",
                             "TownCyc30pct",
                             "TownCar30pct")]

saveRDS(access_town, "C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/data-prepared/access_town.Rds")
unlink("tmp", recursive = TRUE)

dir.create("tmp")
unzip("data-input/DFT Acessability/employment centres.zip", exdir = "tmp")
access_employ <- readxl::read_excel("tmp/employment centres.xls", sheet = "ACS0501-2013")
access_employ <- as.data.frame(access_employ)
names(access_employ) <- access_employ[6,]
access_employ <- access_employ[7:nrow(access_employ),]
access_employ <- access_employ[!is.na(access_employ$`LA Code2`),]
access_employ[6:ncol(access_employ)] <- lapply(access_employ[6:ncol(access_employ)], as.numeric)

access_employ = access_employ[,c("LSOA_code2",
                                 "emplPTtime2,4",
                                 "emplPTfrequency2,4",
                                 "emplcycletime2",
                                 "emplcarnewtime2,3",
                                 "%All20_PT/walk2,4",
                                 "%All20_cycle2",
                                 "%All20_carnew2,3",
                                 "%All20_composite2,4",
                                 "%All40_PT/walk2,4",
                                 "%All40_cycle2",
                                 "%All40_carnew2,3",
                                 "%All40_composite2,4")]

names(access_employ) <- c("LSOA11",
                          "acc_employ_PTtime",
                          "acc_employ_PTfrequency",
                          "acc_employ_cycletime",
                          "acc_employ_cartime",
                          "acc_employ_p20min_PT_walk",
                          "acc_employ_p20min_cycle",
                          "acc_employ_p20min_car",
                          "acc_employ_p20min_composite",
                          "acc_employ_p40min_PT_walk",
                          "acc_employ_p40min_cycle",
                          "acc_employ_p40min_car",
                          "acc_employ_p40min_composite")



saveRDS(access_employ, "data-prepared/access_employ.Rds")
unlink("tmp", recursive = TRUE)


dir.create("tmp")
unzip("data-input/DFT Acessability/food stores.zip", exdir = "tmp")
access_food <- readxl::read_excel("tmp/food stores.xls", sheet = "ACS0507 - 2013")
access_food <- as.data.frame(access_food)
names(access_food) <- access_food[6,]
access_food <- access_food[7:nrow(access_food),]
access_food <- access_food[!is.na(access_food$`LA Code`),]
access_food[6:ncol(access_food)] <- lapply(access_food[6:ncol(access_food)], as.numeric)

access_food = access_food[,c("LSOA_code",
                             "supPTtime1,3",
                             "supPTfrequency1,3",
                             "supcycletime1",
                             "supcarnewtime1,2",
                             "%All15_by PT/walk1,3",
                             "%All15_by cycle1",
                             "%All15_by carnew1,2",
                             "%All15_composite1,3",
                             "%All30_by PT/walk1,3",
                             "%All30_by cycle1",
                             "%All30_by carnew1,2",
                             "%All30_composite1,3")]

names(access_food) <- c("LSOA11",
                        "acc_food_PTtime",
                        "acc_food_PTfrequency",
                        "acc_food_cycletime",
                        "acc_food_cartime",
                        "acc_food_p15min_PT_walk",
                        "acc_food_p15min_cycle",
                        "acc_food_p15min_car",
                        "acc_food_p15min_composite",
                        "acc_food_p30min_PT_walk",
                        "acc_food_p30min_cycle",
                        "acc_food_p30min_car",
                        "acc_food_p30min_composite")



saveRDS(access_food, "data-prepared/access_food.Rds")
unlink("tmp", recursive = TRUE)


dir.create("tmp")
unzip("data-input/DFT Acessability/gp.zip", exdir = "tmp")
access_gp <- readxl::read_excel("tmp/gp.xls", sheet = "ACS0505-2013")
access_gp <- as.data.frame(access_gp)
names(access_gp) <- access_gp[6,]
access_gp <- access_gp[7:nrow(access_gp),]
access_gp <- access_gp[!is.na(access_gp$`LA Code1`),]
access_gp[6:ncol(access_gp)] <- lapply(access_gp[6:ncol(access_gp)], as.numeric)

access_gp = access_gp[,c("LSOA_code1",
                         "gpPTtime1,3",
                         "gpPTfrequency1,3",
                         "gpcycletime1",
                         "gpcarnewtime1,2",
                         "%All15_PT/walk1,3",
                         "%All15_cycle1",
                         "%All15_carnew1,2",
                         "%All30_PT/walk1,3",
                         "%All30_cycle1",
                         "%All30_carnew1,2")]

names(access_gp) <- c("LSOA11",
                      "acc_gp_PTtime",
                      "acc_gp_PTfrequency",
                      "acc_gp_cycletime",
                      "acc_gp_cartime",
                      "acc_gp_p15min_PT_walk",
                      "acc_gp_p15min_cycle",
                      "acc_gp_p15min_car",
                      "acc_gp_p30min_PT_walk",
                      "acc_gp_p30min_cycle",
                      "acc_gp_p30min_car")



saveRDS(access_gp, "data-prepared/access_gp.Rds")
unlink("tmp", recursive = TRUE)


dir.create("tmp")
unzip("data-input/DFT Acessability/primary education.zip", exdir = "tmp")
access_primary <- readxl::read_excel("tmp/primary education.xls", sheet = "ACS0502-2013")
access_primary <- as.data.frame(access_primary)
names(access_primary) <- access_primary[6,]
access_primary <- access_primary[7:nrow(access_primary),]
access_primary <- access_primary[!is.na(access_primary$`LA Code2`),]
access_primary[6:ncol(access_primary)] <- lapply(access_primary[6:ncol(access_primary)], as.numeric)

access_primary = access_primary[,c("LSOA_code",
                                   "psPTtime1,4",
                                   "psPTfrequency1,4",
                                   "pscycletime1",
                                   "pscarnewtime1,2",
                                   "%All15_PT/walk1,4",
                                   "%All15_cycle1",
                                   "%All15_carnew1,2",
                                   "%All30_PT/walk1,4",
                                   "%All30_cycle1",
                                   "%All30_carnew1,2")]

names(access_primary) <- c("LSOA11",
                           "acc_primary_PTtime",
                           "acc_primary_PTfrequency",
                           "acc_primary_cycletime",
                           "acc_primary_cartime",
                           "acc_primary_p15min_PT_walk",
                           "acc_primary_p15min_cycle",
                           "acc_primary_p15min_car",
                           "acc_primary_p30min_PT_walk",
                           "acc_primary_p30min_cycle",
                           "acc_primary_p30min_car")



saveRDS(access_primary, "data-prepared/access_primary.Rds")
unlink("tmp", recursive = TRUE)


dir.create("tmp")
unzip("data-input/DFT Acessability/secondary education.zip", exdir = "tmp")
access_secondary <- readxl::read_excel("tmp/secondary education.xls", sheet = "ACS0503-2013")
access_secondary <- as.data.frame(access_secondary)
names(access_secondary) <- access_secondary[6,]
access_secondary <- access_secondary[7:nrow(access_secondary),]
access_secondary <- access_secondary[!is.na(access_secondary$`LA Name1`),]
access_secondary[6:ncol(access_secondary)] <- lapply(access_secondary[6:ncol(access_secondary)], as.numeric)

access_secondary = access_secondary[,c("LSOA_code1",
                                       "ssPTtime1,3",
                                       "ssPTfrequency1,3",
                                       "sscycletime1",
                                       "sscarnewtime1,2",
                                       "%All20_PT/walk1,3",
                                       "%All20_cycle1",
                                       "%All20_carnew1,2",
                                       "%All40_PT/walk1,3",
                                       "%All40_cycle1",
                                       "%All40_carnew1,2")]

names(access_secondary) <- c("LSOA11",
                             "acc_secondary_PTtime",
                             "acc_secondary_PTfrequency",
                             "acc_secondary_cycletime",
                             "acc_secondary_cartime",
                             "acc_secondary_p20min_PT_walk",
                             "acc_secondary_p20min_cycle",
                             "acc_secondary_p20min_car",
                             "acc_secondary_p40min_PT_walk",
                             "acc_secondary_p40min_cycle",
                             "acc_secondary_p40min_car")



saveRDS(access_secondary, "data-prepared/access_secondary.Rds")
unlink("tmp", recursive = TRUE)
