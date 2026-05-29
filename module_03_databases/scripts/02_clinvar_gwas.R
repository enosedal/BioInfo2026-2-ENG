#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(gwasrapidd)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

thyroid_gwas <- get_associations(
  efo_trait = "thyroid carcinoma"
)

associations_tbl <- associations(thyroid_gwas)

write_csv(
  associations_tbl,
  "../results/table_B_variants.csv"
)

print(head(associations_tbl))
