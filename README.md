# BI_spring2020
# This repository contains workflow for project "Search for genes associated with invasiveness in different genetic lines of *Streptococcus pneumoniae*"
## The goal of the project is to analyze the features of virulence mechanisms for specific genetic lines, based on a comparison of highly virulent and low virulent strains in several datasets, each of which is represented by a single sequence type according to MLST.

### Tasks:
### 1-2. To get acquainted with the prepared datasets of S. pneumoniae, the pubMLST base, to collect de novo genomes.
### 3. Characterize genomes for the presence of determinants of virulence
### 4. Perform genome comparisons in the Genome Comparator for each genetic line.
### 5. Based on the results of the Genome Comparator (presence / absence of a gene, variant of a gene) and preliminary search for known determinants of virulence in genomes, prepare several datasets (separately for each genetic line) for classification.
### 6. Set significant variables involved in the formation of group variables “Source of excretion (cerebrospinal fluid, blood, nasopharynx)” and “Potentially invasive / non-invasive” using classification algorithms
### 7. Assume possible virulence mechanisms associated with the found variables.

## System requirements
12CPU 24Gb, Ubuntu18.04

SRA tools  "fastq-dump" version 2.10.3

FastQC v0.11.5

multiqc, version 1.8

cutadapt 1.15

TrimGalore-0.6.5

GNU parallel 20161222 (http://www.gnu.org/software/parallel,Tange O. et al. Gnu parallel-the command-line power tool //The USENIX Magazine. – 2011. – Т. 36. – №. 1. – С. 42-47.)

MetaPhlAn2

For Unicycler pipeline:

SPAdes-3.14.1-Linux 

makeblastdb 2.6.0+

tblastn 2.6.0+

bowtie2 2.3.4.1

bowtie2-build 2.3.4.1

samtools 1.7

java 11.0.7

R version 3.5.3

R packages dummies, FactoMineR, factoextra


