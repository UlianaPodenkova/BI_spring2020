#!/bin/bash
#To create sh file for downloading paired-end reads from NCBI SRA use this code:

touch get_SRAdata.sh
nano get_SRAdata.sh
#!/usr/bin/bash
fastq-dump --split-e -I --gzip -O ~/data/reads2 --skip-technical $1

#make the file executable
chmod+x get_SRAdata.sh

#finally to start downloading use the command below
cat reads_not_tested | xargs -n 1 bash get_SRAdata.sh