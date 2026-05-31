# ./module_05_ngs_visualization

## Objective

To demonstrate the generation, processing, and visualization of NGS data by accomplishing RNA-seq alignment, genome browser exploration, and genomic signal track creation using best practice bioinformatic workflows.

---

## Background

Visualization is a vital because it enables the direct inspection of results within their context. IGV and UCSC Genome Browser allow us to explore annotations, coverage, structures, and experimental signals at various scales. Proper visualization requires well formatted and indexed files, including those outpute by BAM and BigWig, which ease our access to regions of interest in the genomes.

Here, RNA-seq reads from *Plasmodium chabaudi* were aligned against a reference genome using HISAT2, processed via SAMtools, visualized through genome browser formats. Additionally, we used deepTools, as indicated, to generate coverage tracks which serve for integration into external visualization suites.

---

## Dataset

| Attribute                  | Description                     |
| -------------------------- | ------------------------------- |
| Organism                   | *Plasmodium chabaudi* AS        |
| Data source                | Course-provided RNA-seq dataset |
| Data type                  | Paired-end RNA-seq reads        |
| Samples                    | MT1 and MT2                     |
| Reference genome           | PccAS_v3_genome.fa              |
| Annotation file            | PccAS_v3.gff3                   |
| Browser-compatible outputs | BAM, BAI, BigWig                |

---

## Workflow

FastQC Quality Control
↓
HISAT2 Genome Index Construction
↓
RNA-seq Alignment
↓
SAMtools BAM Processing
↓
BAM Index Generation
↓
BigWig Signal Track Generation
↓
IGV Visualization
↓
UCSC / WashU Browser Compatibility

---

## Tools Used

| Tool                    | Purpose                               |
| ----------------------- | ------------------------------------- |
| FastQC                  | Raw read quality assessment           |
| HISAT2                  | Splice-aware RNA-seq alignment        |
| SAMtools                | BAM conversion, sorting, and indexing |
| deepTools               | BigWig coverage track generation      |
| IGV                     | Interactive genome visualization      |
| UCSC Genome Browser     | External genomic track visualization  |
| WashU Epigenome Browser | Genome-wide signal exploration        |
| Slurm                   | HPC job scheduling                    |
| Linux                   | Workflow execution environment        |

---

## Results

### Key Findings

* RNA-seq reads from MT1 and MT2 were successfully aligned to the *Plasmodium chabaudi* reference genome using HISAT2.
* FastQC quality assessment was performed prior to downstream analyses to verify sequencing quality.
* Sorted and indexed BAM files were generated for efficient genome browser visualization.
* BigWig tracks were produced using deepTools and are compatible with IGV, UCSC Genome Browser, and WashU Epigenome Browser.
* Genome browsers allow dynamic exploration of genomic annotations, transcript structures, and sequencing coverage.
* Zooming across genomic scales reveals different levels of biological information, ranging from chromosome-wide coverage patterns to individual aligned reads.
* Export of data for IGV and UCSC visualization.
* BigWig formatted transcriptomic data.

---

## Discussion

RNA-seq visualization allows us to validate our pipelines inbetween alignment and posterior biological interpretation. Despite the numerical strength of statistical analyses to sum up expression patterns, our genome browsers permit the unfiltered inspection how reads are distributed, how transcript are structured, as well as observing genomic annotations.

HISAT2 is a great tool, which I wish I had used at first, would have saved a LONG time. Since RNA-seq contains transcriptomic reads that often span exon-exon regions, and so need splice-aware alignment algorithms. After we align, SAMtools creates compressed and indexed BAM files that facilitate near instantaneous navigation through ginormous genomic datasets.

As if it were not enough, BigWig enhances visualization by storing genome-wide coverage signals in compressed binary formats. These can be piped into multiple platforms, which permits comparisons with publicly available data and smoothing biological interpretation.

---

## Reproducibility Notes

All analyses were executed within the university HPC environment using Slurm-managed resources. Software environments were managed through the module system and Anaconda environments. The complete workflow, including quality control, alignment, BAM processing, indexing, and BigWig generation, is documented in:

```text
scripts/run_ngs_visualization_pipeline.sh
```

Generated outputs are stored in:

```text
results/qc/
results/alignment/
results/tracks/
```

Within their respective module_0* folder

This organization ensures reproducibility, transparency, and compatibility with browser platforms.
