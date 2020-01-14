#' Get accessibility data for particular year and table number
#'
#' The DfT's Journey Time Statistics are outlined here on the
#' [gov.uk website](https://www.gov.uk/government/statistical-data-sets/journey-time-statistics-data-tables-jts).
#'
#' The function uses a data frame of existing tables, created by the script 'accessibility_tables.R' in the data-raw folder.
#'
#' The tables starting JTS01 to JTS03 provide national overview data.
#' The tables JTS0401 to JTS0409 provide data at the Local Authority level.
#' The tables JTS0501 to JTS0509 provide the same data at the LSOA level.
#' The tables beginning JTS09 provide data on accessibility to transport hubs.
#' And the tables beginning JTS10 contain add other variables.
#'
#' Data is provided every year from 2014 to 2019 in many cases
#' @param table The title of the table, e.g. "jts0501"
#' @param year The year, e.g. 2017
#' @param u_csv The csv url (not usually needed)
#' @param skip How many lines to skip before the data starts (6 by default)
#' @aliases jts_tables
#' @export
#' @examples
#' jts_tables
#' jts_tables$table_title
#' get_jts_data(table = "jts0101", year = 2017, skip = 7)
#' # uncomment on released version
#' # get_jts_data(table = "jts0401", year = 2017)
#' # get_jts_data(table = "jts0402", year = 2017)
#' # get_jts_data(table = "jts0402", year = 2014)
get_jts_data = function(table, year = NULL, u_csv = NULL, skip = 6) {
  table_info = jts_tables[jts_tables$table_code == table, ]
  message("This table's title is ", table_info$table_title[1])
  message("These data files are available for that table code: ", paste0(table_info$csv_file_name, "\n"))
  if(!is.null(year)) {
    csv_file_name = paste0(table, "-", year, ".csv")
    u_original = table_info$table_url[table_info$csv_file_name == csv_file_name]
    u_csv = table_info$csv_url[table_info$csv_file_name == csv_file_name]
  }

  message("Reading in file ", u_csv)
  readr::read_csv(u_csv, skip = skip)
}
download_accessibility_files = function(download_dir = tempdir()) {
  u1 = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853574/journey-time-statistics-2017.pdf"
  utils::download.file(u1, file.path(download_dir, "journey-time-statistics-2017.pdf"))
  u2 = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853576/jts0101-to-jts0408.zip"
  utils::download.file(u2, file.path(download_dir, "jts0101-to-jts0408.zip"))
  u3 = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853579/jts0501-to-jts0503.zip"
  utils::download.file(u3, file.path(download_dir, "jts0501-to-jts0503.zip"))
  u4 = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853581/jts0504-to-jts0508.zip"
  utils::download.file(u4, file.path(download_dir, "jts0504-to-jts0508.zip"))
}


get_accessibility_data_overview = function(download_dir = tempdir(), table_name = "jts0101.ods") {
  u = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/853576/jts0101-to-jts0408.zip"
  f = file.path(download_dir, "jts0101-to-jts0408.zip")
  utils::download.file(u, f)
  utils::unzip(zipfile = f, exdir = download_dir)
  list.files(download_dir)
  readODS::read.ods(file.path(download_dir, table_name))[[1]]
}
utils::globalVariables("jts_tables")


# convert_ods_file_to_csv = function(x) {
#
# }

# download_and_read_ods_file = function(x) {
#   file_name = basename(x)
#   message("Downloading file ", file_name, " from ", x)
#   download.file(x, file_name)
#   readODS::read.ods(file_name)
# }
# x = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/748222/jts0509.ods"
# download_and_read_ods_file(x)
# readODS::read.ods()

# library(readxl)
# library(readODS)
#
# dir.create("Z:/data/tmp")
# utils::unzip("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/jts0504-to-jts0508.zip", exdir = "Z:/data/tmp")
# utils::unzip("C:/Users/geojta/Dropbox/ITS_PCT_Joey/ACTON/Accessibility_Stats/2017_Revised/jts0501-to-jts0503.zip", exdir = "Z:/data/tmp")
#
# #town centre
# access_town <- readxl::read_excel("Z:/data/tmp/jts0508.xlsx")
# # access_town <- readODS::read_ods("Z:/data/tmp/jts0508.ods", sheet = 2, skip = 6)
# access_town <- as.data.frame(access_town)
# # names(access_town) <- access_town[6,]
# # access_town <- access_town[7:nrow(access_town),]
# # access_town <- access_town[!is.na(access_town$LA_Code),]
# # access_town[6:ncol(access_town)] <- lapply(access_town[6:ncol(access_town)], as.numeric)
#
# access_town = access_town[,c("LSOA_code",
#                              "LA_Code",
#                              "TownPTt",
#                              "TownCyct",
#                              "TownCart",
#                              "TownPT15pct",
#                              "TownCyc15pct",
#                              "TownCar15pct",
#                              "TownPT30pct",
#                              "TownCyc30pct",
#                              "TownCar30pct")]
#
# saveRDS(access_town, "../NewDevelopmentsCycling/data/accessibility/access_town.Rds")
#
# #employment
# access_employ <- readxl::read_excel("Z:/data/tmp/jts0501.xlsx")
# access_employ <- as.data.frame(access_employ)
#
# access_employ = access_employ[,c("LSOA_code",
#                                  "LA_Code",
#                                  "100EmpPTt",
#                                  "100EmpCyct",
#                                  "100EmpCart",
#                                  "500EmpPTt",
#                                  "500EmpCyct",
#                                  "500EmpCart",
#                                  "5000EmpPTt",
#                                  "5000EmpCyct",
#                                  "5000EmpCart",
#                                  "100EmpPT15pct",
#                                  "100EmpCyc15pct",
#                                  "100EmpCar15pct",
#                                  "100EmpPT30pct",
#                                  "100EmpCyc30pct",
#                                  "100EmpCar30pct",
#                                  "500EmpPT15pct",
#                                  "500EmpCyc15pct",
#                                  "500EmpCar15pct",
#                                  "500EmpPT30pct",
#                                  "500EmpCyc30pct",
#                                  "500EmpCar30pct",
#                                  "5000EmpPT15pct",
#                                  "5000EmpCyc15pct",
#                                  "5000EmpCar15pct",
#                                  "5000EmpPT30pct",
#                                  "5000EmpCyc30pct",
#                                  "5000EmpCar30pct")]
#
#
# saveRDS(access_employ, "../NewDevelopmentsCycling/data/accessibility/access_employ.Rds")
#
# #food
# access_food <- readxl::read_excel("Z:/data/tmp/jts0507.xlsx")
# access_food <- as.data.frame(access_food)
#
# access_food = access_food[,c("LSOA_code",
#                              "LA_Code",
#                              "FoodPTt",
#                              "FoodCyct",
#                              "FoodCart",
#                              "FoodPT15pct",
#                              "FoodCyc15pct",
#                              "FoodCar15pct",
#                              "FoodPT30pct",
#                              "FoodCyc30pct",
#                              "FoodCar30pct")]
#
#
# saveRDS(access_food, "../NewDevelopmentsCycling/data/accessibility/access_food.Rds")
#
#
# #GP
# access_gp <- readxl::read_excel("Z:/data/tmp/jts0505.xlsx")
# access_gp <- as.data.frame(access_gp)
#
# access_gp = access_gp[,c("LSOA_code",
#                          "LA_Code",
#                          "GPPTt",
#                          "GPCyct",
#                          "GPCart",
#                          "GPPT15pct",
#                          "GPCyc15pct",
#                          "GPCar15pct",
#                          "GPPT30pct",
#                          "GPCyc30pct",
#                          "GPCar30pct")]
#
#
# saveRDS(access_gp, "../NewDevelopmentsCycling/data/accessibility/access_gp.Rds")
#
#
# #primary
# access_primary <- readxl::read_excel("Z:/data/tmp/jts0502.xlsx")
# access_primary <- as.data.frame(access_primary)
#
# access_primary = access_primary[,c("LSOA_code",
#                                    "LA_Code",
#                                    "PSPTt",
#                                    "PSCyct",
#                                    "PSCart",
#                                    "PSPT15pct",
#                                    "PSCyc15pct",
#                                    "PSCar15pct",
#                                    "PSPT30pct",
#                                    "PSCyc30pct",
#                                    "PSCar30pct")]
#
#
# saveRDS(access_primary, "../NewDevelopmentsCycling/data/accessibility/access_primary.Rds")
#
#
# #secondary
# access_secondary <- readxl::read_excel("Z:/data/tmp/jts0503.xlsx")
# access_secondary <- as.data.frame(access_secondary)
#
# access_secondary = access_secondary[,c("LSOA_code",
#                                        "LA_Code",
#                                        "SSPTt",
#                                        "SSCyct",
#                                        "SSCart",
#                                        "SSPT15pct",
#                                        "SSCyc15pct",
#                                        "SSCar15pct",
#                                        "SSPT30pct",
#                                        "SSCyc30pct",
#                                        "SSCar30pct")]
#
#
# saveRDS(access_secondary, "../NewDevelopmentsCycling/data/accessibility/access_secondary.Rds")
#
# # unlink("tmp", recursive = TRUE)
