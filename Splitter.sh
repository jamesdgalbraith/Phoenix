#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=2:00:00
#SBATCH --mem=8GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au


module load BEDTools/2.25.0-foss-2015b


cd ~/Workspace/Merging

# Split repeats up by repeat name to remove duplicate entries
while read REPEAT
do
	awk -v CR1="$REPEAT" '{if ($0 ~ CR1) print $1 "\t" $2 "\t" $3 "\t" 1 "\t" $5 "\t" $4}' ~/Workspace/Merging/merged.bed >> SplitByRepeat.bed

done <"/home/a1194388/Genomes/CR1Names.txt"

	
	# Remove merged.bed to make way for a new one
	rm merged.bed


	# sort the file by chr/scaffold then coordinates
	bedtools sort -i SplitByRepeat.bed > sorted.bed

	# merge overlapping hits
	bedtools merge -s -i sorted.bed -c 4 -o collapse | awk '{print $1 "\t" $2 "\t" $3 "\t" 1 "\t" $5 "\t" $4}' >> merged.bed


#Split repeats into different species
while read SPECIES GENOME
do
	cd ~/Workspace/Merging
	mkdir -p ${SPECIES}
	cd ${SPECIES}

	awk -v species="$SPECIES" '{if ($6 ~ species) print $1 "\t" $2 "\t" $3 "\t" 1 "\t" $5 "\t" $4}' ~/Workspace/Merging/merged.bed >> {SPECIES}"AllCR1s.bed"

done <"/home/a1194388/Genomes/genomes.txt"
