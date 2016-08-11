#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=4:00:00
#SBATCH --mem=4GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au

module load BEDTools/2.25.0-foss-2015b


while read SPECIES GENOME
do
	# make a directory for the species
	mkdir -p $SPECIES

	# seperate out repeats found in species into sepearte bed
	awk -v s="$SPECIES" '{if ($0 ~ s) print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6}' FinalCR1sSpecies.txt >> $SPECIES/$SPECIES"_Censor.bed"

	# get fasta of species repeats
	bedtools getfasta -s -fi ~/Genomes/$SPECIES/$GENOME -bed $SPECIES/$SPECIES"_Censor.bed" -fo $SPECIES/$SPECIES"_Censor.fasta"

done <"/home/a1194388/Scripts/genomes.txt"
