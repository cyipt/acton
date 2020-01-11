## code to prepare dataset accessibility_tables goes here

library(rvest)
library(tidyverse)

u = "https://www.gov.uk/government/statistical-data-sets/journey-time-statistics-data-tables-jts"
html = xml2::read_html(u)

links = html %>%
  rvest::xml_nodes(".attachment-inline .govuk-link")

table_title = rvest::html_text(links)
table_url = rvest::html_attr(links, "href")

accessibility_table = tibble::tibble(
  table_title,
  table_url
)
table_codes_url = str_sub(accessibility_table$table_url, start = 104, 110)
table_codes_url[1:2]
accessibility_table$table_code = table_codes_url

data_dir = "~/hd/data/uk/accessibility/"
i = 1
for(i in i:nrow(accessibility_table)) {
  u = accessibility_table$table_url[i]
  file_to_download = basename(u)
  message("Downloading ", file_to_download)
  download.file(u, file.path(data_dir, file_to_download))
}

f = "~/hd/data/uk/accessibility/jts0101.ods"
o = setwd("~/hd/data/uk/accessibility/")
system("libreoffice --headless --convert-to csv --outdir . *.xlsx")
system("libreoffice --headless --convert-to csv --outdir . 1*.ods") # only converts 1st sheet
system("libreoffice --headless --convert-to xlsx --outdir . *.ods")

list.dirs()
list.files("jts1010-xlsxcsv/")

system("xlsx2csv -a jts0102.xlsx xls2csv") # works, duplicate file names present...

i = 1
for(i in 1:nrow(accessibility_table)) {
  u = accessibility_table$table_url[i]
  ods_file_name = basename(u)
  xlsx_file_name = gsub(pattern = ".ods", replacement = ".xlsx", x = ods_file_name)
  folder_name = gsub(pattern = ".ods", "", ods_file_name)
  msg = paste0("xlsx2csv -a ", xlsx_file_name, " ", folder_name)
  message("Running ", msg)
  system(msg)
  f = list.files(folder_name)
  print(f)
}


list.files(data_dir, pattern = "csv")

folders = list.dirs()
nchar_folders = nchar(folders)
folders_csv = folders[nchar_folders == 9]

dir.create("accessibility_csv_files")
i = folders_csv[1]
for(i in folders_csv) {
  f = list.files(path = i, full.names = TRUE)
  base_names = basename(f)
  new_file_names = file.path("accessibility_csv_files", basename(paste0(i, "-", base_names)))
  file.copy(f, new_file_names)
}

list.files("accessibility_csv_files/")
zip(zipfile = "accessibility_csv_files.zip", files = "accessibility_csv_files/")
file.size("accessibility_csv_files.zip") / 1e6
d = readr::read_csv("accessibility_csv_files/jts0101-2014.csv", skip = 7)
d_meta = readr::read_csv("accessibility_csv_files/jts0501-Metadata.csv")
View(d_meta)
# confirmed: useful data
d = readr::read_csv("accessibility_csv_files/jts0501-2017.csv", skip = 6)


piggyback::pb_upload("accessibility_csv_files.zip", repo = "cyipt/acton")

setwd("accessibility_csv_files/")
f = list.files()
piggyback::pb_upload(f, repo = "cyipt/acton")


# join onto access tables dataset -----------------------------------------

accessibility_table
accessibility_table$table_url[1]
folders_csv
table_codes_csv = basename(folders_csv)
accessibility_table$table_code = table_codes_url
accessibility_table_csvs = tibble::tibble(
  table_code = str_sub(f, start = 1, end = 7),
  csv_file_name = f
)

length(table_codes)
nrow(accessibility_table)
accessibility_table$table_url
jts_tables = left_join(accessibility_table_csvs, accessibility_table)

csv_file_names = paste0(jts_tables$table_code, ".csv")

readr::read_csv("https://github.com/cyipt/acton/releases/download/0.0.1/jts0101-2014.csv")

csv_url = paste0("https://github.com/cyipt/acton/releases/download/0.0.1/", jts_tables$csv_file_name)

readr::read_csv(csv_url[2])

jts_tables$csv_url = csv_url
usethis::use_data(jts_tables)
