usr/bin/env Rscript

# =========================================================
# 07_integrated_summary.R
# Automated multi-omic integration
# =========================================================

suppressPackageStartupMessages({
  library(dplyr)
  library(readr)
})

annotations <- read_csv(
  "../results/table_A_annotations.csv"
)

structures <- read_csv(
  "../results/table_C_structures.csv"
)

interactions <- read_csv(
  "../results/table_F_interactions.csv"
)

integrated <- annotations %>%
  left_join(
    structures,
    by = c("hgnc_symbol" = "Gene")
  )

write_csv(
  integrated,
  "../results/table_I_integrated.csv"
)

print(head(integrated))
