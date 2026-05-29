# ./module_01_cluster_linux

## Objective

Brief description of the biological or computational objective.

---

## Background

Short explanation of the biological concepts involved.

---

## Dataset

| Attribute | Description |
|---|---|
| Organism | |
| Data source | |
| Data type | |
| Number of samples | |
| Experimental conditions | |

---

## Workflow

```
Input Data
    ↓
Quality Control
    ↓
Processing / Alignment
    ↓
Statistical Analysis
    ↓
Visualization
    ↓
Biological Interpretation
```

---

## Tools Used

| Tool | Purpose |
|---|---|
| FastQC | Quality control |
| STAR | Alignment |
| DESeq2 | Differential expression |
| ggplot2 | Visualization |

---

## Results

### Key Findings

- Observation 1
- Observation 2
- Observation 3

---

## Discussion

Interpretation of biological significance and technical considerations.

---

## Reproducibility Notes

Software versions, parameters, and workflow descriptions are documented within the scripts and reports directories.

# ./module_01_cluster_linux

## Objective

To demonstrate knowledge and ease of use with basic cluster concepts, as well as cluster access best practices in the LAVIS UNAM high-performance computing (HPC) cluster.

---

## Background

The implementation of high-throughput bioinformatics pipelines, as well as the nature of large data set collaborative bioinformatic work requires precise and broad knowledge of cluster access, since it enables group level analysis of massive data volumes, while the employment of best practices, or digital etiquette, are a must in order to work in shared environments, to avoid hindering collaborative work, and the accidental total collapse of mutual processing resources.

---

## Dataset

None used.

---

## Workflow

```
Cluster Access (SSH Keys)
↓
Environment Isolation (srun Compute Node Allocation)
↓
Batch Job Automation (sbatch Toy Script Submission)
↓
Storage Volume Optimization (Absolute Path Symlinks)
↓
System Evaluation & Reporting (Documentation & Ticketing Log)
```

---

## Tools Used

| Tool | Purpose |
|---|---|
| OpenSSH | Encrypted remote terminal authentication |
| Slurm Workload Manager | Node resource arbitration (`srun`, `sbatch`, `squeue`) |
| GNU Coreutils | Filesystem structure construction and stream manipulation |
| Git Engine | Chronological version control and distributed tracking |

---

## Results

### Key Findings

- Use of cluster and account generation
- Interactive module and job requests
- Error report and program requests through ticketing
- File system best practices
- Symlink generation from absolute routes

---

## Discussion

HPC allows the processing and meaningful analysis of biological data that would otherwise be inaccesible due to its sheer scale. Digital etiquette allows the collaboration and parallelization of tasks by setting guidelines that ensure users don't hinder each other and the data produced remain closely aligned to FIRM standards.

---

## Reproducibility Notes

Software environments are managed dynamically via the system module sub-architecture (`Lmod`). Exact task configurations, resource footprints (`--mem=1G`), tracking logs, and admin interaction patterns are formally archived in the execution script repository (`./scripts/toy_job.sh`).
