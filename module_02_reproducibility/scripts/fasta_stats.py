#!/usr/bin/env python3

"""
fasta_stats.py

Simple FASTA parser for basic sequence statistics.

Author: enosedal
Course: Bioinformatics Good Practices
"""

import sys


def calculate_stats(target_fasta_path):
    total_sequences_found = 0
    accumulated_sequence_length = 0

    try:
        with open(target_fasta_path, "r") as open_fasta_file:
            for current_line in open_fasta_file:
                if current_line.startswith(">"):
                    total_sequences_found += 1
                else:
                    # Clean trailing newlines to ensure accurate character counting
                    clean_nucleotide_string = current_line.strip()
                    accumulated_sequence_length += len(clean_nucleotide_string)

        print(f"Number of sequences: {total_sequences_found}")
        print(f"Total sequence length: {accumulated_sequence_length}")

    except FileNotFoundError:
        print("ERROR: FASTA file not found.")
        sys.exit(1)


if __name__ == "__main__":

    if len(sys.argv) != 2:
        print("Usage: python fasta_stats.py <fasta_file>")
        sys.exit(1)

    calculate_stats(sys.argv[1])
