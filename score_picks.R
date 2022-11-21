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
picks <- read_csv("GS1_picks.csv")
attach(picks)

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))



picks2 <- select(picks,-c(1,2))


GS1 <- matches %>%
  filter (Round == "GS1") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 

match_names <- names(picks2)[1:length(GS1)]
  
  # temporalmente se dejará asi
G1_all <- map_dfc(1:length(GS1),~if_else( GS1[.x] == picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

GS1 <- rowSums(GS1_all)






### Escribir el output
scores <- data.frame(numero_participante,Nombre,GS1) %>%
          group_by (numero_participante) %>%
          mutate(Total = sum(GS1)) %>%
          ungroup %>%
          arrange(desc(Total),numero_participante)
scores_GS1 <- data_frame(numero_participante,Nombre,GS1_all)

write.table(scores,"Overall_scores.csv",quote = F,sep=",",row.names = F)

write.table(scores_GS1, "GS1_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )

