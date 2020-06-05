#!/bin/bash

#Contamination analysis using MetaPhlAn2
#Firstly, we downloaded MetaPhlAn2

wget -P ~/soft  https://www.dropbox.com/s/ztqr8qgbo727zpn/metaphlan2.zip?dl=0

#Since we wanted to analyze many samples at the same time, we wrote this:

for f in *.fastq.gz;
do python2 /root/soft/metaphlan2/metaphlan2.py $f --input_type fastq --nproc 1 > ${f%.fastq.gz}_profile.txt ;
done

#Finally, the MetaPhlAn2 distribution includes a utility script that will create a single tab-delimited table from these files:

/root/soft/metaphlan2/utils/merge_metaphlan_tables.py *_profile.txt > merged_abundance_table.txt
 
#Run the following command to create a species only abundance table, providing the abundance table ( merged_abundance_table.txt ) created in prior tutorial steps:

grep -E "(s__)|(^ID)" merged_abundance_table.txt | grep -v "t__" | sed 's/^.*s__//g' > merged_abundance_table_species.txt

#There are three parts to this command. The first grep searches the file for the regular expression "(s__)|(^ID)" which matches to those lines with species information and also to the header. 
#The second grep does not print out any lines with strain information (labeled as t__). 
#The sed removes the full taxonomy from each line so the first column only includes the species name.
#The new abundance table (merged_abundance_table_species.txt) will contain only the species abundances with just the species names (instead of the full taxonomy).