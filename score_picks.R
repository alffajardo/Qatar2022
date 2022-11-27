#!/usr/local/bin/Rscript

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
GS1_picks <- read_csv("GS1_picks.csv")

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))



GS1_picks2 <- select(GS1_picks,-c(1,2))


GS1 <- matches %>%
  filter (Round == "M1") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 

attach(GS1_picks)

match_names <- names(GS1_picks2)[1:length(GS1)]
  
  # temporalmente se dejará asi
GS1_all <- map_dfc(1:length(GS1),~if_else( GS1[.x] == GS1_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

cumsum_gs1 <- apply(GS1_all,1,cumsum)

GS1 <- rowSums(GS1_all)

# Calificar la ronda 2
GS2_picks <- read_csv("GS2_picks.csv")

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))



GS2_picks2 <- select(GS2_picks,-c(1,2))


GS2 <- matches %>%
  filter (Round == "M2") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 


match_names <- names(GS2_picks2)[1:length(GS2)]

# temporalmente se dejará asi
GS2_all <- map_dfc(1:length(GS2),~if_else( GS2[.x] == GS2_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


GS2 <- rowSums(GS2_all)

### Escribir el output
scores <- data.frame(numero_participante,Nombre, GS1,GS2) %>%
  group_by (numero_participante) %>%
  mutate(Total = sum(GS1,GS2)) %>%
  ungroup %>%
  arrange(desc(Total),numero_participante)

scores_GS2 <- data.frame(numero_participante,Nombre,GS2_all)

scores_GS1 <- data.frame(numero_participante,Nombre,GS1_all)

write.table(scores,"Overall_scores.csv",quote = F,sep=",",row.names = F)

write.table(scores_GS1, "GS1_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_GS2, "GS2_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )

