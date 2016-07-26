#!/bin/bash

# used to make a query from a query BED

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=30:00
#SBATCH --mem=32GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au

module load BEDTools/2.25.0-foss-2015b

cd /home/a1194388/Run06/Lastz/Query

# label species of each repeat
join <(sort Query06.bed) ~/Scripts/SpeciesContigs.txt > Q06.bed

# retab .bed
sed 's/ /	/g' Q06.bed >> Joined_Q06.bed

while read SPECIES GENOME
do

# extract repeats of the species into its bed
awk -v s=${SPECIES} '{if ($0 ~ s) print $1 "\t" $2 "\t" $3 "\t" $4 "\t" 1 "\t" $6}' Joined_Q06.bed >> ${SPECIES}'_Q06.bed'

# extract fasta of repeats
bedtools getfasta -fi ~/Genomes/${SPECIES}/*.fasta -bed ${SPECIES}'_Q06.bed' -fo ${SPECIES}'_Q06.fasta'

# add species' repeats fasta to query fasta
cat ${SPECIES}'_Q06.fasta' >> Query06.fasta

done <"/home/a1194388/Scripts/genomes.txt"

# remove un-needed files
rm *Q06*
