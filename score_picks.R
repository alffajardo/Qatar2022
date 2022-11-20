#!/usr/bin/Rscript

library(googlesheets4)
library(googledrive)
library(dplyr)
library(tidyr)
library(readr)
library(purrr)

# read the data
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks <- read_csv("GS1_picks.csv") %>%
  select(-Round)
attach(picks)

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))

result_M1 <- matches$Result

picks2 <- select(picks,-c(1,2))

puntos <- map_dfc(1:length(result),~result[.x] == picks2[,.x]) %>%
  rowSums()


scores <- data.frame(numero_participante,Nombre,puntos) %>%
          arrange(desc(puntos))

write.table(scores,"scores.csv",quote = F,sep=",",row.names = F)


