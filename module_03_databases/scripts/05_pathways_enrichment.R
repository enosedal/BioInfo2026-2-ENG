#!/usr/bin/env Rscript

suppressPackageStartupMessages({
  library(clusterProfiler)
  library(org.Hs.eg.db)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

gene_df <- bitr(
  genes,
  fromType = "SYMBOL",
  toType = "ENTREZID",
  OrgDb = org.Hs.eg.db
)

if (nrow(gene_df) == 0) {
  stop("No genes mapped to ENTREZ IDs")
}

ego <- enrichGO(
  gene = gene_df$ENTREZID,
  OrgDb = org.Hs.eg.db,
  ont = "BP",
  pAdjustMethod = "BH",
  readable = TRUE
)

ego_df <- as.data.frame(ego)

# 🔥 FIX: flatten ANY list columns (this is your crash source)
flatten_list_cols <- function(df) {
  df %>%
    mutate(across(where(is.list), ~sapply(.x, function(x) {
      if (is.null(x)) return(NA)
      paste(x, collapse = ";")
    })))
}

ego_clean <- flatten_list_cols(ego_df)

write_csv(
  ego_clean,
  "../results/table_E_pathways.csv"
)

print(head(ego_clean))
