library(googledrive)
library(googlesheets4)

picks_id <- drive_find(type = "spreadsheet",pattern = "Group_Stage1"
 ,n_max = 1)$id

picks <- googlesheets4::read_sheet(picks_id)
