#!/bin/bash
#SBATCH --job-name=test_job
#SBATCH --output=out_logs/test_job.out
#SBATCH --error=out_logs/test_job.err
#SBATCH --time=00:02:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem=1G

echo "Starting test job..."
hostname
date

sleep 90

echo "Job completed."
date
