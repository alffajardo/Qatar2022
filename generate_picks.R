library(googledrive)
library(googlesheets4)
library(tidyverse)

picks_id <- drive_find(type = "spreadsheet",pattern = "GroupStage1_respuestas",
n_max = 1)$id

matches_id <- drive_find(type = "spreadsheet",pattern = "matches"
 ,n_max = 1)$id

matches <- read_sheet(matches_id)
picks <- read_sheet(picks_id)

bets <- picks[,c(5,4,6:ncol(picks))] %>%
data.frame()


write.table(bets,"picks_table_test.txt",sep=" ",quote = F,
row.names =F )




apply(bets,2,function(x){
    ifelse(x==matches$Local,1,0)
})

