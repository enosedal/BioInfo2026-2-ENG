#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(httr)
  library(readr)
  library(dplyr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

query <- paste(genes, collapse = "%0d")

url <- paste0(
  "https://string-db.org/api/tsv/network?identifiers=",
  query,
  "&species=9606"
)

tmp <- tempfile(fileext = ".tsv")

GET(url, write_disk(tmp, overwrite = TRUE))

df <- read.delim(tmp)
df <- df %>% filter(score > 0.7)

write_csv(df, "../results/table_F_interactions.csv")
print(head(df))
