#!/bin/bash

# =========================================================
# Slurm Resource Allocations
# =========================================================
#SBATCH --job-name=ngs_visualization
#SBATCH --output=scripts/out_logs/slurm-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=8G
#SBATCH --time=04:00:00

# =========================================================
# NGS Visualization Pipeline
# Module 05 - Visualización de datos de NGS
# UNAM ENES Juriquilla
# Efrén Nosedal González
# =========================================================

set -euo pipefail

echo "=========================================="
echo "Starting NGS Visualization Pipeline"
echo "=========================================="

# =========================================================
# Environment & Directories
# =========================================================
module purge
module load fastqc
module load hisat2
module load samtools
module load anaconda3

source activate deeptools-2.5.3

PROJECT_DIR="/mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_05_ngs_visualization"
DATA_DIR="${PROJECT_DIR}/data"
RESULTS_DIR="${PROJECT_DIR}/results"

# Establish a clean, organized directory hierarchy immediately
mkdir -p "${RESULTS_DIR}/qc"
mkdir -p "${RESULTS_DIR}/alignment"
mkdir -p "${RESULTS_DIR}/tracks"

cd "${RESULTS_DIR}"

# =========================================================
# 1. FASTQC (Fixed: Output explicitly mapped to results/qc)
# =========================================================
echo "[1/6] Running FastQC"

fastqc -t 4 -o "${RESULTS_DIR}/qc" \
  "${DATA_DIR}/MT1_1.fastq" \
  "${DATA_DIR}/MT1_2.fastq" \
  "${DATA_DIR}/MT2_1.fastq" \
  "${DATA_DIR}/MT2_2.fastq"

# =========================================================
# 2. HISAT2 INDEX
# =========================================================
echo "[2/6] Building HISAT2 index"

hisat2-build \
  "${DATA_DIR}/PccAS_v3_genome.fa" \
  "${RESULTS_DIR}/alignment/PccAS_v3_hisat2.idx"

# =========================================================
# 3. MT1 ALIGNMENT, CONVERSION & SORT (Piped to save disk space)
# =========================================================
echo "[3/6] Aligning and sorting MT1"

hisat2 -p 4 --max-intronlen 10000 \
  -x "${RESULTS_DIR}/alignment/PccAS_v3_hisat2.idx" \
  -1 "${DATA_DIR}/MT1_1.fastq" \
  -2 "${DATA_DIR}/MT1_2.fastq" \
  | samtools view -Sb - \
  | samtools sort -@ 4 -o "${RESULTS_DIR}/alignment/MT1.sorted.bam"

# =========================================================
# 4. MT2 ALIGNMENT, CONVERSION & SORT (Piped to save disk space)
# =========================================================
echo "[4/6] Aligning and sorting MT2"

hisat2 -p 4 --max-intronlen 10000 \
  -x "${RESULTS_DIR}/alignment/PccAS_v3_hisat2.idx" \
  -1 "${DATA_DIR}/MT2_1.fastq" \
  -2 "${DATA_DIR}/MT2_2.fastq" \
  | samtools view -Sb - \
  | samtools sort -@ 4 -o "${RESULTS_DIR}/alignment/MT2.sorted.bam"

# =========================================================
# 5. INDEX BAM
# =========================================================
echo "[5/6] Indexing BAM files"

samtools index "${RESULTS_DIR}/alignment/MT1.sorted.bam"
samtools index "${RESULTS_DIR}/alignment/MT2.sorted.bam"

# =========================================================
# 6. BIGWIG GENERATION
# =========================================================
echo "[6/6] Generating BigWig tracks"

bamCoverage -p 4 \
  -b "${RESULTS_DIR}/alignment/MT1.sorted.bam" \
  -o "${RESULTS_DIR}/tracks/MT1.bw"

bamCoverage -p 4 \
  -b "${RESULTS_DIR}/alignment/MT2.sorted.bam" \
  -o "${RESULTS_DIR}/tracks/MT2.bw"

echo "=========================================="
echo "Pipeline completed successfully"
echo "=========================================="
