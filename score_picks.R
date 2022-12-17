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

GS1 <- rowSums(GS1_all)

scores_GS1 <- data.frame(numero_participante,Nombre,GS1_all)
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

scores_GS2 <- data.frame(numero_participante,Nombre,GS2_all)


# Calificar la ronda 3
GS3_picks <- read_csv("GS3_picks.csv")

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor),
         Score = paste(Goals_Local,"-",Goals_Visitor,sep=""))



GS3_picks2 <- select(GS3_picks,-c(1,2))


GS3 <- matches %>%
  filter (Round == "M3") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 


match_names <- names(GS3_picks2)[1:length(GS3)]

# temporalmente se dejará asi
GS3_all <- map_dfc(1:length(GS3),~if_else( GS3[.x] == GS3_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


GS3 <- rowSums(GS3_all)

scores_GS3 <- data.frame(numero_participante,Nombre,GS3_all)

# Calificar la roinda de octavos
KO8_picks <- read_csv("KO8_picks.csv")
KO8_picks[21,1:2] <- ""

KO8_picks2 <- select(KO8_picks,-c(1,2))


KO8 <- matches %>%
  filter (Round == "KO8") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 


match_names <- names(KO8_picks2)[1:length(KO8)]


KO8_all <- map_dfc(1:length(KO8),~if_else( KO8[.x] == KO8_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


KO8 <- rowSums(KO8_all,na.rm = T)

scores_KO8 <- data.frame(numero_participante,Nombre,KO8_all)


# calificar el marcador

KO8_goals <- matches %>%
             filter(Round == "KO8") %>%
             select(Score) %>%
             as.vector() %>%
              unlist()

KO8_predicted_scores <- read_csv("KO8_predicted_scores.csv") %>%
                        select(-c(1:2))
KO8_predicted_scores[21,1:2] <- ""

KO8_score_bonus <- map_dfc(1:length(KO8_goals),~if_else( KO8_goals[.x] == KO8_predicted_scores[,.x],true = 1,0)) %>%
  set_names(match_names)

KO8_bonus <- rowSums(KO8_score_bonus,na.rm = T)

KO8_score_bonus <- data.frame(numero_participante,Nombre,KO8_score_bonus)

## Cuartos

KO4_picks <- read_csv("KO4_picks.csv")

KO4_picks2 <- select(KO4_picks,-c(1,2))


KO4 <- matches %>%
  filter (Round == "KO4") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 
match_names <- names(KO4_picks2)[1:length(KO4)]



KO4_all <- map_dfc(1:length(KO4),~if_else( KO4[.x] == KO4_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


KO4 <- rowSums(KO4_all,na.rm = T)

scores_KO4 <- data.frame(numero_participante,Nombre,KO4_all)


# calificar el marcador

KO4_goals <- matches %>%
  filter(Round == "KO4") %>%
  select(Score) %>%
  as.vector() %>%
  unlist()

KO4_predicted_scores <- read_csv("KO4_predicted_scores.csv") %>%
  select(-c(1:2))

KO4_score_bonus <- map_dfc(1:length(KO4_goals),~if_else( KO4_goals[.x] == KO4_predicted_scores[,.x],true = 1,0)) %>%
  set_names(match_names)

KO4_bonus <- rowSums(KO4_score_bonus,na.rm = T)

KO4_score_bonus <- data.frame(numero_participante,Nombre,KO4_score_bonus)

# SEMIFINALES 
KO2_picks <- read_csv("KO2_picks.csv")

KO2_picks2 <- select(KO2_picks,-c(1,2))


KO2 <- matches %>%
  filter (Round == "KO2") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 
  match_names <- names(KO2_picks2)[1:length(KO2)]



KO2_all <- map_dfc(1:length(KO2),~if_else( KO2[.x] == KO2_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


KO2 <- rowSums(KO2_all,na.rm = T)

scores_KO2 <- data.frame(numero_participante,Nombre,KO2_all)


# calificar el marcador

KO2_goals <- matches %>%
  filter(Round == "KO2") %>%
  select(Score) %>%
  as.vector() %>%
  unlist()

KO2_predicted_scores <- read_csv("KO2_predicted_scores.csv") %>%
  select(-c(1:2))

KO2_score_bonus <- map_dfc(1:length(KO2_goals),~if_else( KO2_goals[.x] == KO2_predicted_scores[,.x],true = 1,0)) %>%
  set_names(match_names)

KO2_bonus <- rowSums(KO2_score_bonus,na.rm = T)

KO2_score_bonus <- data.frame(numero_participante,Nombre,KO2_score_bonus)

# FINALES 
KOFinal_picks <- read_csv("KOFinal_picks.csv")

KOFinal_picks2 <- select(KOFinal_picks,-c(1,2))


KOFinal <- matches %>%
  filter (Round == "Final") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 
match_names <- names(KOFinal_picks2)[1:length(KOFinal)]



KOFinal_all <- map_dfc(1:length(KOFinal),~if_else( KOFinal[.x] == KOFinal_picks2[,.x],true = 1,0)) %>%
  set_names(match_names)


KOFinal <- rowSums(KOFinal_all,na.rm = T)

scores_KOFinal <- data.frame(numero_participante,Nombre,KOFinal_all)


# calificar el marcador

KOFinal_goals <- matches %>%
  filter(Round == "Final") %>%
  select(Score) %>%
  as.vector() %>%
  unlist()

KOFinal_predicted_scores <- read_csv("KOFinal_predicted_scores.csv") %>%
  select(-c(1:2))

KOFinal_score_bonus <- map_dfc(1:length(KOFinal_goals),~if_else( KOFinal_goals[.x] == KOFinal_predicted_scores[,.x],true = 1,0)) %>%
  set_names(match_names)

KOFinal_bonus <- rowSums(KOFinal_score_bonus,na.rm = T)

KOFinal_score_bonus <- data.frame(numero_participante,Nombre,KOFinal_score_bonus)




### Escribir el output
scores <- data.frame(numero_participante,Nombre, GS1,GS2,GS3,
                     KO8,KO8_bonus,
                     KO4, KO4_bonus,
                     KO2, KO2_bonus) %>%
  group_by (numero_participante) 

scores <- scores %>%
  mutate(Total = sum(GS1,GS2,GS3,KO8,KO8_bonus,
                     KO4,KO4_bonus,
                     KO2,KO2_bonus,
                     na.rm = T)) %>%
  ungroup %>%
  arrange(desc(Total),numero_participante)



write.table(scores,"Overall_scores.csv",quote = F,sep=",",row.names = F)

write.table(scores_GS1, "GS1_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_GS2, "GS2_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_GS3, "GS3_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_KO8, "KO8_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(KO8_score_bonus, "KO8_complete_bonus.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_KO4, "KO4_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(KO4_score_bonus, "KO4_complete_bonus.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_KO2, "KO2_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(KO2_score_bonus, "KO2_complete_bonus.csv",sep = ",",
            quote = F ,row.names = F )
write.table(scores_KOFinal, "KOFinal_complete_scores.csv",sep = ",",
            quote = F ,row.names = F )
write.table(KOFinal_score_bonus, "KOFinal_complete_bonus.csv",sep = ",",
            quote = F ,row.names = F )


