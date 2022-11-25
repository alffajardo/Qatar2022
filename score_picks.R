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
picks <- read_csv("GS1_picks.csv")
attach(picks)

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id


matches <- read_sheet(matches) %>%
  filter(complete.cases(.)) %>% 
  mutate(GD = abs(Goals_Local - Goals_Visitor))



picks2 <- select(picks,-c(1,2))


GS1 <- matches %>%
  filter (Round == "M1") %>%
  select(Result) %>%
  as.vector() %>%
  unlist() 

match_names <- names(picks2)[1:length(GS1)]
  
  # temporalmente se dejará asi
GS1_all <- map_dfc(1:length(GS1),~if_else( GS1[.x] == picks2[,.x],true = 1,0)) %>%
  set_names(match_names)

cumsum_gs1 <- apply(GS1_all,1,cumsum)

GS1 <- rowSums(GS1_all)

#  time series plots

# draw the axis

plot(cumsum_gs1)

par(mar = par()$mar + 0.1 )
colors <- rainbow(24)
plot(1:nrow(cumsum_gs1),1:nrow(cumsum_gs1),type = "n", axes = F,ylab = "Puntos",xlab='',
     ylim = c(0, max(cumsum_gs1)),main = "Acumulativo")
# axis x
axis(at = 1:nrow(cumsum_gs1),labels = rownames(cumsum_gs1),
     side = 1,padj = T,outer = F,xpd = F, las = 2, cex.axis = 0.7)
# y axis
axis(at = 0:max(cumsum_gs1), side = 2)

# draw the lines

for (i in 1:24){
  
  points(cumsum_gs1[,i], col = colors[i],pch = 20,cex = 1.3)
  
}

for (i in 1:24){
  
  lines(cumsum_gs1[,i], col = colors[i]))
  
}



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

