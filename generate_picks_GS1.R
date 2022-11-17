library(googledrive)
library(googlesheets4)
library(tidyverse)
library(imager)
library(viridis)


picks_id <- drive_find(type = "spreadsheet",pattern = "Group_Stage1_respuestas",
n_max = 1)$id

matches_id <- drive_find(type = "spreadsheet",pattern = "matches"
 ,n_max = 1)$id

matches <- read_sheet(matches_id)

picks <- read_sheet(picks_id) %>%
filter(complete.cases(.)) %>%
select(-c(22,23))

picks$ID_participante <- as.character( as.character(picks$ID_participante)) %>%
                        str_pad(pad = "0", side = "left", width = 3)

bets <- picks[,c(5,4,6:ncol(picks))] %>%
tibble() %>%
arrange(ID_participante)


write.table(bets,"GS1_picks.csv",sep=",",
quote = F,
row.names =F )

# transform the table to markdown
system("./gen_markdown_table.sh --csv < GS1_picks.csv > GS1_Picks.md ")


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
    mar = c( 3,3,3,3))

lapply(1:16, function(x){
pie(result_pics[[x]],col = plasma(3),
    main = names(result_pics)[x],
)
}
)
dev.off()

