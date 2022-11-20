#!/usr/bin/Rscript

library(googlesheets4)
library(googledrive)
library(dplyr)
library(tidyr)
library(readr)

# read the data
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks <- read_csv("GS1_picks.csv") %>%
  pivot_longer(names_to = "Match",
               values_to = "Pick",3:18)%>%
  nest(-Match)

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)$id

matches <- read_sheet(matches) %>%
  filter(complete.cases(.))



