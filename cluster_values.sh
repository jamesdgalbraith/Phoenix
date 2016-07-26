#!/bin/bash

# Written for desktop, to be used on phoenix will need paths changed

while read SPECIES GENOME
do

cd /Users/jamesgalbraith/Data/Initial/Cluster/Refined/usearch/cluster_fast

mkdir ${SPECIES}

cd ${SPECIES}


for num in 0.70 0.75 0.80 0.85 0.90 0.95

	do


	echo $SPECIES $num
	
	#Sort sequences by length
	usearch -sortbylength /Users/jamesgalbraith/Data/Initial/Cluster/Refined/Queries/${SPECIES}/${SPECIES}'_Refined.fasta' -fastaout ${SPECIES}'_all_cluster_cons_ready.fasta'

	#usearch -cluster_fast ${SPECIES}'_fulllength_L1s.fasta' -id $num -uc ${SPECIES}'_results_'${num} -qmask none
	usearch -cluster_fast ${SPECIES}'_all_cluster_cons_ready.fasta' -id $num -uc ${SPECIES}'_results_'${num} -qmask none

	awk '$1 == "C" && $3 != 1 {print $3 "\t" $1 "\t" $2 "\t" $9}' ${SPECIES}'_results_'${num} >> ${SPECIES}'_'${num}'_filtered'
	sort -k1nr,1 ${SPECIES}'_'${num}'_filtered' >> ${SPECIES}'_'${num}'_sorted'
	awk '{sum+=$1} END {print sum}' ${SPECIES}'_'${num}'_sorted'


	done

rm *_filtered
rm *_results_*

done <"/Users/jamesgalbraith/Data/genomes.txt"
