# ./module_04_alignment

## Objective

To familirize oneself with high-throughput sequence alignment workflows and quality-control procedures by processing, aligning, and evaluating ChIP-seq datasets from both pro and eu -karyotic models using industry standard bioinformatics tools.

---

## Background

Sequence alignment is foundational in modern genomics analysis. Before we can interpret biology itselfc, raw sequencing reads must be assessed for quality, mapped against an appropriate reference, and checked for alignment performance. Quality-control metrics help identify artifacts, adapter contamination, duplication, and biases that may affect downstream analysis.

---

## Dataset

| Attribute                | Description                              |
| ------------------------ | ---------------------------------------- |
| Organism 1               | *Escherichia coli* K12 MG1655            |
| Organism 2               | *Mus musculus* (mm10 assembly)           |
| Data source              | Course-provided ChIP-seq datasets        |
| Data type                | High-throughput sequencing reads (FASTQ) |
| Experiment 1             | FNR ChIP-seq                             |
| Experiment 2             | CEBPA ChIP-seq                           |
| Alignment software       | BWA-MEM                                  |
| Quality-control software | FastQC, SAMtools, BCFTools               |

---

## Workflow

FASTQ Quality Assessment (FastQC)
↓
Reference Genome Preparation
↓
Read Alignment (BWA-MEM)
↓
SAM/BAM Conversion and Sorting
↓
BAM Index Generation
↓
Alignment Statistics (flagstat / stats)
↓
Quality Evaluation and Biological Interpretation
↓
Report Generation (RMarkdown)

---

## Tools Used

| Tool                  | Purpose                                               |
| --------------------- | ----------------------------------------------------- |
| BWA-MEM               | Alignment of sequencing reads to reference genomes    |
| SAMtools              | BAM manipulation, indexing, and statistical summaries |
| BCFtools              | Variant file interrogation and BCF analysis           |
| FastQC                | Sequencing quality-control evaluation                 |
| Slurm                 | HPC job scheduling and resource management            |
| RMarkdown             | Dynamic report generation and documentation           |
| Linux Shell Utilities | Data extraction and workflow automation               |

---

## Results

### Key Findings

- Quality control assessment of raw sequencing reads using FastQC
- Inspection and interpretation of BAM, BCF, and alignment statistics files
- Extraction of sequencing metadata from BAM headers
- Variant interrogation and filtering using bcftools
- Alignment of E. coli ChIP-seq reads against the K12 MG1655 reference genome
- Alignment of mouse CEBPA ChIP-seq paired-end reads against the mm10 reference genome
- Generation of sorted and indexed BAM files
- Evaluation of mapping quality and alignment performance using samtools flagstat and samtools stats
- Construction of a reproducible alignment workflow using BWA, SAMtools, BCFtools, and FastQC
- Documentation of all analyses in RMarkdown reports

### E. coli Alignment

* Total reads: 3,603,544
* Mapped reads: 2,351,799
* Mapping rate: 65.26%
* Error rate: 0.001997

### Mouse Alignment

* Total reads: 53,280,064
* Mapped reads: 42,654,988
* Mapping rate: 80.06%
* Properly paired reads: 40,299,012
* Properly paired rate: 75.64%
* Error rate: 0.008893

### FastQC Summary

* FastQC identified expected ChIP-seq enrichment patterns in both datasets.
* Adapter contamination was not detected.
* Mouse sequencing reads displayed consistently high base-quality scores.
* Several sequence composition and duplication warnings were observed, which are common characteristics of enrichment-based sequencing experiments.

---

## Discussion

This module displays the complete transition from raw data to alignment-ready datasets. The underlines the importance of quality assessment before alignment and showcases how mapping statistics are the metric to evaluate datasets for downstream analyses.

---

## Reproducibility Notes

All analyses were executed within the HPC environment using module-managed software installations. The complete workflow is documented in `./scripts/module04_pipeline.sh`, while generated outputs are organized under `./results/`. Assignment reports are maintained within `./report/`, and execution logs are preserved under `./scripts/out_logs/`.

The workflow was designed to be fully reproducible through scripted execution and standardized directory organization.
