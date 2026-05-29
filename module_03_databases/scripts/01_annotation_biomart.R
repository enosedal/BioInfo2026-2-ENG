#!/usr/bin/env Rscript

# =========================================================
# 01_annotation_biomart.R
# Bioinformatics Course - UNAM ENES Juriquilla
# Module 03 - Database Exploration
# =========================================================

suppressPackageStartupMessages({
  library(biomaRt)
  library(dplyr)
  library(readr)
})

genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

mart <- useEnsembl(
  biomart = "genes",
  dataset = "hsapiens_gene_ensembl"
)

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

write_csv(
  annotations,
  "../results/table_A_annotations.csv"
)

print(head(annotations))
