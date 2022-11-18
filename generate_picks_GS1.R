#!/usr/bin/Rscript

library(googledrive)
library(googlesheets4)
library(tidyverse)
library(png)

options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks_id <- drive_find(type = "spreadsheet",pattern = "Group_Stage1_respuestas",
n_max = 1)$id

matches_id <- drive_find(type = "spreadsheet",pattern = "matches"
 ,n_max = 1)$id

matches <- read_sheet(matches_id)

picks <- read_sheet(picks_id) %>%
filter(complete.cases(.)) %>%
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
,  res = 196)
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





