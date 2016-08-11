#!/bin/bash

module load BEDTools/2.25.0-foss-2015b

mkdir -p ~/Clustering/Censor/${SPECIES}/Results/Checking
cd ~/Clustering/Censor/${SPECIES}/Results/Checking

# Identify repeats with reverse segments
cat ../*_Censor.fasta.map | awk '{if ($7=="c") print $1 }' | sort -u | sed 's/(+)/fwd/' | sed 's/(-)/rev/' > NeedChecking.txt

# Find coordinates of possible reverse repeats
while read REPEAT
do

        cat ../*_Censor.fasta.map | sed 's/(+)/fwd/' | sed 's/(-)/rev/' | awk -v r="$REPEAT" '{if ($1 ~ r) print $0}' | sed 's/fwd/(+)/' | sed 's/rev/(-)/' | awk '{print $1 "\t" $4}' | sed 's/:/\t/g' | sed 's/(-)/.rev/g' | sed 's/(+)/.fwd/g' | awk '{gsub(/-/,"\t",$2); print}' | sed 's/.rev/\t-/g' | sed 's/.fwd/\t+/g' | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" "1" "\t" $4}' >> NeedChecking.bed
        
done <"/home/a1194388/Clustering/Censor/${SPECIES}/Results/Checking/NeedChecking.txt"


# sort the file by chr/scaffold then coordinates
bedtools sort -i NeedChecking.bed > sorted.bed

# merge overlapping hits
bedtools merge -s -i sorted.bed -c 4 -o collapse | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" 1 "\t" $4}' > ${SPECIES}_NeedChecking.bed

# Extract FASTA
bedtools getfasta -s -fi /home/a1194388/Genomes/${SPECIES}/*.fasta -bed ${SPECIES}_NeedChecking.bed -fo ${SPECIES}_NeedChecking.fasta

rm NeedChecking.bed sorted.bed
