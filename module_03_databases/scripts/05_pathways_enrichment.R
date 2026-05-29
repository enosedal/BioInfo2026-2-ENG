#!/usr/bin/env Rscript

# =========================================================
# 05_pathways_enrichment.R
# Automated GO enrichment analysis
# =========================================================

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

ego <- enrichGO(
  gene = gene_df$ENTREZID,
  OrgDb = org.Hs.eg.db,
  ont = "BP",
  pAdjustMethod = "BH",
  readable = TRUE
)

ego_df <- as.data.frame(ego)

write_csv(
  ego_df,
  "../results/table_E_pathways.csv"
)

print(head(ego_df))
