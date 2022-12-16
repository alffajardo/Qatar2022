#!/usr/local/bin/Rscript

library(googledrive)
library(googlesheets4)
library(corrplot)
library(viridis)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
library(ggplot2)
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks_id <- drive_find(type = "spreadsheet",pattern = "KO_StageFinal_respuestas",
n_max = 1)$id



picks <- read_sheet(picks_id)

picks$numero_participante <- as.character( as.character(picks$numero_participante)) %>%
                        str_pad(pad = "0", side = "left", width = 3)

bets <- picks[,c(5,4,6:ncol(picks))] %>%
tibble() %>%
arrange(numero_participante) %>%
  select(!ends_with("score"))

scores_prediction <- picks %>%
                    arrange(numero_participante) %>%
                    select(numero_participante,Nombre,ends_with("score"))
  
  


write.table(bets,"KOFinal_picks.csv",sep=",",
quote = F,
row.names =F )


write.table(scores_prediction,"KOFinal_predicted_scores.csv",sep=",",
            quote = F,
            row.names =F )



# Lets make some stats with the bets

bets2 <- pivot_longer(bets,3:ncol(bets),
                        names_to = "Match",
                        values_to = "Bet")



bets2_summary <- bets2 %>%
  group_by(Match) %>%
  count(Bet,na.rm = T) %>%
  ungroup() %>%
  arrange(desc(n)) %>%
  filter(complete.cases(.))
  
bets2_summary$Bet <- factor(bets2_summary$Bet,levels = bets2_summary$Bet)
bets2_summary$Match <- factor(bets2_summary$Match)

plot1 <- ggplot(bets2_summary,aes(x=Match,y = n,fill = Bet))+
  geom_bar(stat = "identity",width = 0.8)+
  ylim(c(0,24))+
  ggtitle("Predicciones (ganadores)")+
  theme_minimal()+
  theme(axis.text.x = element_text(face = 2,angle = 60,
  vjust = T,hjust = T))+
  xlab(" ")+
  ylab("Frecuencia")

ggsave("picks_KOFinal.png",plot = plot1,units = "px",width = 1200,height = 1200,
       path = "media",dpi = 200,bg =  "white")

## calculate an histogram

 plot2 <- scores_prediction %>%
          filter(complete.cases(.)) %>%
  pivot_longer(cols = -c(1,2),names_to = "Match",values_to = "Score") %>%
  group_by(Match) %>%
  count(Score) %>%
  ggplot(aes(x = Score, y = n))+
    geom_bar(stat = "identity",fill="skyblue2")+
    facet_wrap(~Match,scales = "free")+
  theme_minimal()+
    theme(axis.text.x = element_text( face = 2, angle = 65))+
    xlab(" ")+
    ylab("Frecuencia")

  ggsave("predicted_scores_KOFinal.png",plot = plot2,units = "px",width = 1200,height = 1000,
        path = "media",dpi = 200,bg="white")

  