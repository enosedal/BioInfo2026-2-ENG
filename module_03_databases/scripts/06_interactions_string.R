#!/usr/bin/env Rscript

# =========================================================
# 06_interactions_string.R
# Automated STRING interaction retrieval
# =========================================================

suppressPackageStartupMessages({
  library(STRINGdb)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

string_db <- STRINGdb$new(
  version = "12",
  species = 9606,
  score_threshold = 700
)

gene_df <- data.frame(
  gene = genes
)

mapped <- string_db$map(
  gene_df,
  "gene",
  removeUnmappedRows = TRUE
)

interactions <- string_db$get_interactions(
  mapped$STRING_id
)

write_csv(
  interactions,
  "../results/table_F_interactions.csv"
)

print(head(interactions))
