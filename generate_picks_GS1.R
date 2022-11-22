#!/usr/bin/Rscript

library(googledrive)
library(googlesheets4)
library(corrplot)
library(viridis)
library(png)
library(dplyr)
library(readr)
library(stringr)
library(tidyr)
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks_id <- drive_find(type = "spreadsheet",pattern = "Group_Stage1_respuestas",
n_max = 1)$id



picks <- read_sheet(picks_id) %>%
select(-c(22,23))

picks$numero_participante <- as.character( as.character(picks$numero_participante)) %>%
                        str_pad(pad = "0", side = "left", width = 3)

bets <- picks[,c(5,4,6:ncol(picks))] %>%
tibble() %>%
arrange(numero_participante)




write.table(bets,"GS1_picks.csv",sep=",",
quote = F,
row.names =F )




# Lets make some stats with the bets

bets2 <- pivot_longer(bets,3:ncol(bets),
                        names_to = "Match",
                        values_to = "Bet") %>%
                        nest(-`Match`)

## Calculate statistics  per game

result_pics <- lapply(1:16,function(x){
    freqs <- bets2$data[[x]]$Bet %>%
    table()
    prop <- prop.table(freqs)
    return(prop)

}) %>%
setNames(bets2$Match)



png("media/01.picks_stage1.png",width = 20,height = 20,units = "cm",
    res = 196)
par(mfrow = c(4,4),
    mar = c( 3,3,3,3),
    bg = "gray85")




colors <- c("black","tomato3","darkolivegreen")

lapply(1:16, function(x){

    Match <- as.character(x) %>%
        str_pad(side = "left",pad = "0",width = 2) %>%
        paste("flags/matches/Match",.,".png",sep = '')

match_image <- readPNG(Match)
pie(result_pics[[x]],col = colors,
    main = names(result_pics)[x],
   border = "NA")

}
)
dev.off()

#  veamos quien puede subir of bajar más en la tabla

bets2 <- bets[,3:ncol(bets)]
dims <- dim(bets2)

similarities <- matrix(NA, dims[1],dims[1],
dimnames = list(bets$numero_participante,bets$numero_participante))

for (i in 1:nrow(bets2) ){
x <- bets2[i,]
y <- apply(bets2,1,"==",x) %>%
    colSums
similarities[i,] <- y

}


similarities <- similarities / 16 * 100
diag(similarities) <- NA

png(filename = "media/similarities_S1.png",
    width = 10,height = 10,units = "cm",res = 196)
par = c(bg = "gray85")
corrplot(similarities,
method = "color",
col = plasma(50), diag = F,
addgrid.col = T,tl.col = "Black",
order = "hclust",   main = "Similitud entre jugadores",
mar = c(1,1,1,1),cex.main = 1,
is.corr = F,
type = "full",
hclust.method = "ward.D",tl.cex = 0.5,
number.digits = 0,cl.cex = 0.5)

dev.off()

delta_participants <- colMeans(similarities,na.rm = T)

bets$delta <- delta_participants

top <- bets %>%
arrange(delta) %>%
select(1:2) %>%
head(n = 5)

write.table(top,"top_GS1.csv", 
    sep = ',', 
    quote = F, 
    row.names = F)

