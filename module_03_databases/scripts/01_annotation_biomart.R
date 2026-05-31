#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(biomaRt)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

cache_file <- "../results/cache_ensembl_annotations.csv"

# ---------------------------------------------------------
# 1. If cache exists, use it (NO INTERNET DEPENDENCY)
# ---------------------------------------------------------
if (file.exists(cache_file)) {

  message("Using cached Ensembl annotations...")

  annotations <- read_csv(cache_file, show_col_types = FALSE)

  write_csv(annotations, "../results/table_A_annotations.csv")

  print(head(annotations))

  quit(save = "no")
}

# ---------------------------------------------------------
# 2. Try live Ensembl connection (HPC-safe)
# ---------------------------------------------------------
mart <- tryCatch({

  message("Connecting to Ensembl...")

  useEnsembl(
    biomart = "genes",
    dataset = "hsapiens_gene_ensembl",
    mirror = "useast"
  )

}, error = function(e) {

  message("Ensembl unavailable. Falling back to cached data requirement.")

  return(NULL)
})

if (is.null(mart)) {
  stop("Ensembl is unreachable and no cache exists. Run later or prebuild cache.")
}

# ---------------------------------------------------------
# 3. Query Ensembl
# ---------------------------------------------------------
annotations <- getBM(
  attributes = c(
    "hgnc_symbol",
    "ensembl_gene_id",
    "chromosome_name",
    "start_position",
    "end_position",
    "gene_biotype",
    "description",
    "go_id"
  ),
  filters = "hgnc_symbol",
  values = genes,
  mart = mart
)

# ---------------------------------------------------------
# 4. Save outputs (both working table + cache)
# ---------------------------------------------------------
write_csv(annotations, "../results/table_A_annotations.csv")
write_csv(annotations, cache_file)

print(head(annotations))
