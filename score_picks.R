#!/usr/bin/Rscript

library(googlesheets4)
library(googledrive)
library(dplyr)
library(readr)

# read the data
options(gargle_oauth_email = TRUE)
drive_auth(email = TRUE)

picks <- read_csv("GS1_picks.csv")

matches <- drive_find(pattern = "matches",type = "spreadsheet",n_max=1)
