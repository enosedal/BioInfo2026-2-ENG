#!/bin/bash
#SBATCH --job-name=bioinfo_pipeline
#SBATCH --output=/mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_03_databases/scripts/out_logs/slurm-%j.out
#SBATCH --error=/mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_03_databases/scripts/out_logs/slurm-%j.err
#SBATCH --time=04:00:00
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G

set -euo pipefail

module purge

module load gcc/14
module load r/4.4.1-ybalderas

# 🔥 CRITICAL FIX: ensure correct libstdc++
export LD_LIBRARY_PATH=/cm/shared/apps/gcc/14/lib64:$LD_LIBRARY_PATH

cd /mnt/data/bioinfo-estadistica-2/enosedal/BioInfo2026-2-ENG/module_03_databases/scripts/

bash run_pipeline.sh
