#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

annotations <- read_csv("../results/table_A_annotations.csv")
structures  <- read_csv("../results/table_C_structures.csv")

integrated <- annotations %>%
  left_join(structures, by = c("hgnc_symbol" = "Gene"))

write_csv(integrated, "../results/table_I_integrated.csv")
print(head(integrated))
