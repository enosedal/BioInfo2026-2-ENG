# Sequence Alignment — Key Concepts

## What is alignment?

We are Mmapping sequencing reads to a reference genome to infer origin.

---

## Core challenges

* Large search space (genomes are about 3 Gb)
* Millions of reads
* Sequencing errors
* Repetitive regions leads to multi-mapping

---

## Smith-Waterman

* Local alignment algorithm
* Uses dynamic programming
* Too slow for NGS so used only for refinement

---

## Modern aligners (BWA)

Use:

* indexing (FM-index/BWT)
* seed-and-extend strategy
* hash-based filtering

---

## Mapping Quality

Confidence score of alignment:

Q = -10 log10(P(error))

* Q0 → ambiguous mapping
* Q20 → 1% error probability
* Q30 → 0.1% error probability

---

## SAM/BAM/BCF

* SAM: text alignment
* BAM: compressed binary
* BCF: binary variant format

---

## Key idea

Alignment is probabilistic, not exact.
