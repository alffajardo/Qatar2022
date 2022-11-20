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


# Calificar la ronda 1
picks <- read_csv("GS1_picks.csv") %>%
  select(-Round)
attach(picks)

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))



picks2 <- select(picks,-c(1,2))


M1 <- matches %>%
  filter (Round == "M1") %>%
  select(Result) %>%
  as.vector() %>%
  unlist()

M1_all <- map_dfc(1:length(M1),~M1[.x] == picks2[,.x]) %>%

M1 <- rowSums(M1)





### Escribir el output
scores <- data.frame(numero_participante,Nombre,M1) %>%
          group_by (numero_participante) %>%
          mutate(Total = sum(M1)) %>%
          ungroup %>%
          arrange(desc(Total))

write.table(scores,"scores.csv",quote = F,sep=",",row.names = F)


