#!/bin/bash
# Unicycler assembling
while read i; do unicycler -1 “$i”_1_val_1.fq.gz -2 “$i”_2_val_2.fq.gz  -o /mnt/data/assembl2 -t 10 --spades_path /home/daria/soft/SPAdes-3.14.1-Linux/bin/spades.py
 ; done < my_reads

# -1 and -2 - paired-end reads
# -o output directory
# -t number of threads used (default: 8)
# --spades_path Path to the SPAdes executable
# my_reads - list of reads id's ready for assembling