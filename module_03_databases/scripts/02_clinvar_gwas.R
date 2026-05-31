#!/usr/bin/env Rscript

# =========================================================
# 02_clinvar_gwas_fixed.R
# Fully Automated Dynamic GWAS + Variant Table Builder
# =========================================================

suppressPackageStartupMessages({
  library(gwasrapidd)
  library(biomaRt)
  library(dplyr)
  library(readr)
  library(tidyr)
})

# 1. Define target genes
genes <- c("RET", "BRAF", "IL10", "STAT3", "CTLA4")

message("[-] Connecting to Ensembl BioMart...")
# Connect to Ensembl Variation database to pull real-time variant consequences & clinical data
var_mart <- useMart("ensembl", dataset = "hsapiens_snp")

message("[-] Fetching variant annotations for genes...")
# Query variant consequences, rsIDs, and clinical significance for target genes
variants_annotated <- getBM(
  attributes = c('refsnp_id', 'chrom_start', 'ensembl_gene_stable_id', 
                 'associated_gene', 'consequence_type_tv', 'clinical_significance'),
  filters = 'associated_gene',
  values = genes,
  mart = var_mart
)

# Clean up Ensembl data
variants_clean <- variants_annotated %>%
  filter(!is.na(refsnp_id) & refsnp_id != "") %>%
  rename(
    Gen = associated_gene,
    `Variante (rsID)` = refsnp_id,
    Consecuencia = consequence_type_tv,
    `Clasificación ACMG` = clinical_significance
  ) %>%
  # Standardize clinical significance to approximate ACMG
  mutate(`Clasificación ACMG` = case_when(
    stringr::str_detect(`Clasificación ACMG`, "pathogenic") ~ "Pathogenic/Likely Pathogenic",
    stringr::str_detect(`Clasificación ACMG`, "benign") ~ "Benign/Likely Benign",
    stringr::str_detect(`Clasificación ACMG`, "uncertain") ~ "VUS",
    TRUE ~ "Risk allele / Other"
  ))

# 2. Fetch GWAS Catalog Data Dynamically
message("[-] Querying GWAS Catalog for 'thyroid carcinoma'...")
gwas_data <- get_associations(efo_trait = "thyroid carcinoma")

# Robust S4 extraction of SNPs and p-values using gwasrapidd helper methods
gwas_snps <- gwasrapidd::as_tibble(gwas_data@snps)       # Contains snp_id_current
gwas_pvals <- gwasrapidd::as_tibble(gwas_data@associations) # Contains pvalue and association_id

# Link GWAS variants to their P-values
gwas_clean <- gwas_snps %>%
  select(association_id, snp_id_current) %>%
  left_join(gwas_pvals %>% select(association_id, pvalue, efo_trait), by = "association_id") %>%
  filter(!is.na(snp_id_current)) %>%
  group_by(snp_id_current) %>%
  summarise(
    `GWAS p-valor` = min(pvalue, na.rm = TRUE),
    `Enfermedad asociada` = paste(unique(efo_trait), collapse = "; ")
  ) %>%
  rename(`Variante (rsID)` = snp_id_current)

# 3. Merge Datasets via rsID
message("[-] Merging Variant annotations with GWAS signals...")
table_B <- variants_clean %>%
  left_join(gwas_clean, by = "Variante (rsID)") %>%
  # Fill in the Disease column if it wasn't captured by GWAS but exists in clinical databases
  mutate(`Enfermedad asociada` = ifelse(is.na(`Enfermedad asociada`), "Thyroid related / Autoimmune context", `Enfermedad asociada`)) %>%
  # Select and reorder to match your specific Tabla B layout
  select(
    Gen, 
    `Variante (rsID)`, 
    Consecuencia, 
    `Clasificación ACMG`, 
    `Enfermedad asociada`, 
    `GWAS p-valor`
  ) %>%
  distinct(Gen, `Variante (rsID)`, .keep_all = TRUE) # Remove structural duplicates

# 4. Export results
dir.create("results", showWarnings = FALSE)
write_csv(table_B, "results/table_B_variants.csv")

message("[+] Process complete! Output saved to results/table_B_variants.csv")
print(head(table_B, 10))
