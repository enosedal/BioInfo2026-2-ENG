#!/bin/bash

# =========================================================
# Slurm Resource Allocations
# =========================================================
#SBATCH --job-name=db_pipeline
#SBATCH --output=slurm-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=4G
#SBATCH --time=02:00:00

# =========================================================
# Bioinformatics Database Exploration Pipeline
# UNAM ENES Juriquilla
# Efrén Nosedal González
# =========================================================

echo "=========================================="
echo "Starting Bioinformatics Pipeline"
echo "=========================================="

# 1. Environment initialization for cluster compute nodes
module purge
module load r

# 2. Use Slurm's native variable to find your project directory
# Then jump straight into your scripts folder dynamically
cd /mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_03_databases/scripts
echo "Current execution directory: $(pwd)"

echo "[0/7 Running R package installer...]"
Rscript install_packages.R

echo "[1/7] Running biomaRt annotation..."
Rscript 01_annotation_biomart.R

echo "[2/7] Running ClinVar/GWAS retrieval..."
Rscript 02_clinvar_gwas.R

echo "[3/7] Running structural annotation..."
Rscript 03_structure_pdb.R

echo "[4/7] Running GEO expression analysis..."
Rscript 04_expression_geo.R

echo "[5/7] Running pathway enrichment..."
Rscript 05_pathways_enrichment.R

echo "[6/7] Running STRING interactions..."
Rscript 06_interactions_string.R

echo "[7/7] Building integrated summary..."
Rscript 07_integrated_summary.R

echo "=========================================="
echo "Pipeline completed successfully"
echo "=========================================="
