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
* 12CPU 24Gb, Ubuntu18.04
* SRA tools  "fastq-dump" version 2.10.3 ( https://github.com/ncbi/sra-tools )
* FastQC v0.11.5 ( https://www.bioinformatics.babraham.ac.uk/projects/fastqc/ )
* multiqc, version 1.8 ( https://multiqc.info/ )
* cutadapt 1.15
* TrimGalore-0.6.5 ( https://www.bioinformatics.babraham.ac.uk/projects/trim_galore/ )
* GNU parallel 20161222 (http://www.gnu.org/software/parallel Tange O. et al. Gnu parallel-the command-line power tool //The USENIX Magazine. – 2011. – Т. 36. – №. 1. – С. 42-47.)
* MetaPhlAn2 ( https://huttenhower.sph.harvard.edu/metaphlan )
* For Unicycler pipeline:
  * SPAdes-3.14.1-Linux ( http://cab.spbu.ru/software/spades/ )
  * makeblastdb 2.6.0+
  * tblastn 2.6.0+
  * bowtie2 2.3.4.1 ( http://bowtie-bio.sourceforge.net/bowtie2/index.shtml )
  * bowtie2-build 2.3.4.1
  * samtools 1.7  ( http://www.htslib.org/ )
  * java 11.0.7
* R version 3.5.3
* R packages dummies, FactoMineR, factoextra


## Pipeline
1. __Downloading reads__ .
We had a list of id's named “reads_not_tested”. To download paired reads from NCBI SRA I wrote this script:
```{bash}
touch get_SRAdata.sh
nano get_SRAdata.sh
#!/usr/bin/bash
fastq-dump --split-e -I --gzip -O ~/data/reads2 --skip-technical $1

chmod+x get_SRAdata.sh

cat reads_not_tested | xargs -n 1 bash get_SRAdata.sh
```
2. __Quality control__ 
using FastQC and MultiQC 

```{bash}
fastqc  *.fastq.gz; multiqc *.zip >> data/read_qc
```
In output directory multiqc_data we found file multiqc_fastq.txt , containing quality reports. To get a list of reads with a coverage of more than 30, we used the following command:
```{bash}
awk -F'\t' '{if((($10*$5)/2130580)>30)print$1}' <multiqc_fastqc.txt 
```
(2130580 - genome size of *S.pneumoniae*)

3. __Trimming__ using Trim Galore and GNU Parallel
```{bash}
parallel --xapply ~/data/reads/TrimGalore-0.6.5/trim_galore --paired --cores 4 --path_to_cutadapt /home/uliana/.local/bin/cutadapt --fastqc -o trim_galore/ ::: *_1.fastq.gz ::: *_2.fastq.gz
```

4. Repeated __quality check__. Fastqc was included into Trim Galore, so using multiqc we checked GC% (39-42) and adapters
```{bash}
multiqc *.zip
awk -F'\t' '{print$21}’ <multiqc_fastqc.txt 
```

5. __Contamination analysis__ using MetaPhlAn2
 Firstly, we downloaded MetaPhlAn2
```{bash}
wget -P ~/soft  https://www.dropbox.com/s/ztqr8qgbo727zpn/metaphlan2.zip?dl=0
```
Since we wanted to analyze many samples at the same time, we wrote this:
```{bash}
for f in *.fastq.gz;
do python2 /root/soft/metaphlan2/metaphlan2.py $f --input_type fastq --nproc 1 > ${f%.fastq.gz}_profile.txt ;
done
```
Finally, the MetaPhlAn2 distribution includes a utility script that will create a single tab-delimited table from these files:
```{bash}
/root/soft/metaphlan2/utils/merge_metaphlan_tables.py *_profile.txt > merged_abundance_table.txt
```
Run the following command to create a species only abundance table, providing the abundance table ( merged_abundance_table.txt ) created in prior tutorial steps:
```{bash}
grep -E "(s__)|(^ID)" merged_abundance_table.txt | grep -v "t__" | sed 's/^.*s__//g' > merged_abundance_table_species.txt

```
There are three parts to this command. The first grep searches the file for the regular expression "(s__)|(^ID)" which matches to those lines with species information and also to the header. The second grep does not print out any lines with strain information (labeled as t__). The sed removes the full taxonomy from each line so the first column only includes the species name.

The new abundance table (merged_abundance_table_species.txt) will contain only the species abundances with just the species names (instead of the full taxonomy). We had 100% of *S.pneumoniae* detected in our data.

6. Assembling *de novo*. Thus, we formed a list of reads to assemble named "my_reads". Using Unicycler - an assembly pipeline for bacterial genomes. It can assemble Illumina read sets where it functions as a SPAdes-optimiser.
Command to start the assembling :
```{bash}
while read i; do unicycler -1 “$i”_1_val_1.fq.gz -2 “$i”_2_val_2.fq.gz  -o /mnt/data/assembl2 -t 10 --spades_path /home/daria/soft/SPAdes-3.14.1-Linux/bin/spades.py
 ; done < my_reads
```
7. Using the Genome Comparator (pubMLST, https://pubmlst.org/bigsdb?db=pubmlst_spneumoniae_isolates_pgl ) we performed a comparison of *de novo* assembled *S.pneumoniae* genomes 81 sequence type.
Genomes of *S.pneumoniae* isolates from blood and cerebrospinal fluid were compared with genomes of isolates from the nasopharynx of the same genetic line. Thus as a result of comparison, we received a table with different alleles of the detected genes (we tested the core genome of *S.pneumoniae*), table named __variable1__.
To perform the further analysis we created new table, containing id's of samples and source of their extraction (blood/cerebrospinal fluid/nasopharynx), named __id81source__

8. We uploaded tables __variable1__ and __id81source__ in RStudio and performed PCA analysis using  dummies, FactoMineR snd factoextra packages. 


## Results
* The PCA analysis showed that groups of isolates from carriers and patients actually form separate clusters.
* We also established significant variables involved in the formation of the group variable “source of extraction”, for example, genes encoding Acetyltransferase, GNAT family; 6-phospho-beta-glucosidase (Gene Comparator detected new alleles).
It is necessary to analyze the literature to understand exactly how these genes affect the invasiveness of *S.pneumoniae*.
Thus, we completed almost all the tasks, obtained valid results and a lot of data for further research.

![Illustration PCA](https://github.com/UlianaPodenkova/BI_spring2020/raw/master/EzD51XtpV8I.png)
![Illustration PCA2](https://github.com/UlianaPodenkova/BI_spring2020/raw/master/res1.png)
![Illustration PCA2](https://github.com/UlianaPodenkova/BI_spring2020/raw/master/phosphobetaglucosidase.png)
## References
1. PubMLST.org
2. Tange O. et al. Gnu parallel-the command-line power tool //The USENIX Magazine. – 2011. – Т. 36. – №. 1. – С. 42-47.
3. MultiQC: Summarize analysis results for multiple tools and samples in a single report Philip Ewels, Måns Magnusson, Sverker Lundin and Max Käller Bioinformatics (2016)
4. FastQC: A Quality Control Tool for High Throughput Sequence Data [Online]. Available online at: http://www.bioinformatics.babraham.ac.uk/projects/fastqc/ (2015)
5. Wick R. R. et al. Unicycler: resolving bacterial genome assemblies from short and long sequencing reads //PLoS computational biology. – 2017. – Т. 13. – №. 6. – С. e1005595.
6. Metagenomic microbial community profiling using unique clade-specific marker genes
Nicola Segata, Levi Waldron, Annalisa Ballarini, Vagheesh Narasimhan, Olivier Jousson, Curtis Huttenhower. Nature Methods, 8, 811–814, 2012

