#!/bin/bash

# =========================================================
# Slurm Resource Allocations
# =========================================================
#SBATCH --job-name=module04_alignment
#SBATCH --output=scripts/out_logs/slurm-%j.out
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00

# =========================================================
# Sequence Alignment and QC Module
# BioInfo2026-2-ENG
# Efrén Nosedal González
# =========================================================
set -e
set -u
set -o pipefail

echo "=========================================="
echo "Starting Module 04 Pipeline"
echo "=========================================="

# =========================================================
# Environment
# =========================================================
module purge
module load bwa/0.7.19
module load samtools/1.20
module load bcftools/1.17
module load fastqc/0.11.3

PROJECT_DIR=/mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_04_alignment
DATA=${PROJECT_DIR}/data
RESULTS=${PROJECT_DIR}/results

mkdir -p scripts/out_logs
mkdir -p ${RESULTS}/qc/bam
mkdir -p ${RESULTS}/qc/bcf
mkdir -p ${RESULTS}/qc/stats
mkdir -p ${RESULTS}/ecoli
mkdir -p ${RESULTS}/mouse

cd ${PROJECT_DIR}
echo "Current directory: $(pwd)"

# =========================================================
# SECTION A
# FORMATOS QC
# =========================================================
echo "[1/14] Extracting BAM header"
samtools view -H \
  ${DATA}/NA20538.bam \
  > ${RESULTS}/qc/bam/bam_header.txt

echo "[2/14] Extracting first aligned read"
# Temporarily turning off pipefail so head -1 closing the pipe doesn't crash samtools
set +o pipefail
samtools view ${DATA}/NA20538.bam | head -1 > ${RESULTS}/qc/bam/first_read.txt
set -o pipefail

echo "[3/14] BAM statistics"
samtools stats \
  -F SECONDARY \
  ${DATA}/NA20538.bam \
  > ${RESULTS}/qc/stats/bam_stats.txt

echo "[4/14] BCF sample list"
bcftools query -l \
  ${DATA}/1kg.bcf \
  > ${RESULTS}/qc/bcf/sample_list.txt

echo "[5/14] Number of samples"
bcftools query -l \
  ${DATA}/1kg.bcf \
  | wc -l \
  > ${RESULTS}/qc/bcf/sample_count.txt

echo "[6/14] HG00107 genotype at chr20:24019472"
bcftools query \
  -r 20:24019472 \
  -s HG00107 \
  -f '[ %TGT]\n' \
  ${DATA}/1kg.bcf \
  > ${RESULTS}/qc/bcf/HG00107_genotype_20_24019472.txt

echo "[7/14] Sites with more than 10 alternate alleles"
bcftools view \
  -i 'INFO/AC>10' \
  ${DATA}/1kg.bcf \
  > ${RESULTS}/qc/bcf/more_than_10_alt_alleles.vcf

echo "[8/14] HG00107 non-reference calls with DP > 10"
bcftools query \
  -s HG00107 \
  -f '%CHROM\t%POS[\t%GT]\n' \
  ${DATA}/1kg.bcf \
  > ${RESULTS}/qc/bcf/HG00107_all_genotypes.txt

# =========================================================
# SECTION B
# E. COLI ALIGNMENT
# =========================================================
echo "[9/14] FastQC on E. coli ChIP-seq reads"
fastqc \
  -o ${RESULTS}/ecoli \
  ${DATA}/SRX189773_FNR_ChIP.fastq

echo "[10/14] Building E. coli BWA index"
bwa index \
  ${DATA}/Escherichia_coli_K12_MG1655.fasta

echo "[11/14] Aligning and sorting E. coli reads on the fly"
bwa mem -t 4 \
  ${DATA}/Escherichia_coli_K12_MG1655.fasta \
  ${DATA}/SRX189773_FNR_ChIP.fastq \
  | samtools view -u - \
  | samtools sort -@ 4 -o ${RESULTS}/ecoli/ecoli_sorted.bam

samtools index \
  ${RESULTS}/ecoli/ecoli_sorted.bam

samtools flagstat \
  ${RESULTS}/ecoli/ecoli_sorted.bam \
  > ${RESULTS}/ecoli/ecoli_flagstat.txt

samtools stats \
  ${RESULTS}/ecoli/ecoli_sorted.bam \
  > ${RESULTS}/ecoli/ecoli_stats.txt

# =========================================================
# SECTION C
# MOUSE ALIGNMENT
# =========================================================
echo "[12/14] FastQC on mouse paired-end reads"
fastqc \
  -o ${RESULTS}/mouse \
  ${DATA}/SRR8376646_CEBPA_musmusculus_1.fastq.gz

fastqc \
  -o ${RESULTS}/mouse \
  ${DATA}/SRR8376646_CEBPA_musmusculus_2.fastq.gz

echo "[13/14] Aligning and sorting mouse reads on the fly"
bwa mem -t 4 \
  ${DATA}/mm10_bwa-0.7_index/mm10.fa \
  ${DATA}/SRR8376646_CEBPA_musmusculus_1.fastq.gz \
  ${DATA}/SRR8376646_CEBPA_musmusculus_2.fastq.gz \
  | samtools view -u - \
  | samtools sort -@ 4 -o ${RESULTS}/mouse/mouse_sorted.bam

samtools index \
  ${RESULTS}/mouse/mouse_sorted.bam

echo "[14/14] Mouse alignment statistics"
samtools flagstat \
  ${RESULTS}/mouse/mouse_sorted.bam \
  > ${RESULTS}/mouse/mouse_flagstat.txt

samtools stats \
  ${RESULTS}/mouse/mouse_sorted.bam \
  > ${RESULTS}/mouse/mouse_stats.txt

echo "=========================================="
echo "Module 04 Pipeline Completed Successfully"
echo "=========================================="
