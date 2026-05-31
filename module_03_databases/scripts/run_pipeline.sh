#!/bin/bash

set -euo pipefail

echo "=========================================="
echo "BIOINFO PIPELINE START"
echo "=========================================="

BASE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$BASE_DIR"

LOG="out_logs/pipeline_$(date +%F_%H-%M-%S).log"
exec > >(tee -a "$LOG") 2>&1

echo "[INFO] Working directory: $BASE_DIR"
echo "[INFO] Log file: $LOG"
echo "[INFO] Start time: $(date)"

# =========================================================
# STEP 1 — Annotation
# =========================================================
echo ""
echo "[1/7] Running annotation..."
Rscript 01_annotation_biomart.R

# =========================================================
# STEP 2 — GWAS / ClinVar
# =========================================================
echo ""
echo "[2/7] Running GWAS/ClinVar..."
Rscript 02_clinvar_gwas.R

# =========================================================
# STEP 3 — Structure
# =========================================================
echo ""
echo "[3/7] Running structural analysis..."
Rscript 03_structure_pdb.R

# =========================================================
# STEP 4 — Expression
# =========================================================
echo ""
echo "[4/7] Running expression analysis..."
Rscript 04_expression_geo.R

# =========================================================
# STEP 5 — Pathways
# =========================================================
echo ""
echo "[5/7] Running pathway enrichment..."
Rscript 05_pathways_enrichment.R

# =========================================================
# STEP 6 — Interactions
# =========================================================
echo ""
echo "[6/7] Running interaction network..."
Rscript 06_interactions_string.R

# =========================================================
# STEP 7 — Integration
# =========================================================
echo ""
echo "[7/7] Building integrated summary..."
Rscript 07_integrated_summary.R

echo ""
echo "=========================================="
echo "PIPELINE COMPLETED SUCCESSFULLY"
echo "=========================================="
echo "End time: $(date)"
