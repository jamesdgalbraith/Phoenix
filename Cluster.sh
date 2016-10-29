#!/bin/bash

while read SPECIES GENOME
do 

cat ${SPECIES}/${SPECIES}''.fasta >> AllSpecies.fasta

usearch -sortbylength AllSpecies.fasta -fastaout AllSpeciesSorted.fasta

done <"/Users/jamesgalbraith/Scripts/genomes.txt"



for num in 0.70 0.75 0.80 0.85 0.90 0.95
	do
	
	
	usearch -cluster_fast AllSpecies'Sorted.fasta' -id ${num} -uc AllSpecies'_results_'${num}

	awk '$1 == "C" && $3 != 1 {print $3 "\t" $1 "\t" $2 "\t" $9}' AllSpecies'_results_'${num} >> AllSpecies'_results_'${num}'_filtered'
	sort -k1nr,1 AllSpecies'_results_'${num}'_filtered' >> AllSpecies'_results_'${num}'_sorted'
	awk '{sum+=$1} END {print sum}' AllSpecies'_results_'${num}'_sorted'
	


done <"Users/jamesgalbraith/Scripts/genomes.txt"

rm *_filtered
