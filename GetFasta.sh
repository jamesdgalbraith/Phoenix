#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1 
#SBATCH -n 4 
#SBATCH --time=4:00:00 
#SBATCH --mem=16GB 

# Notification configuration 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au


module load BEDTools/2.25.0-foss-2015b


cd ~/Workspace/Merging


#Split repeats into different species
while read SPECIES GENOME
do
        cd ~/Workspace/Merging
        mkdir -p ${SPECIES}
        cd ${SPECIES}

        awk -v species="$SPECIES" '{if ($0 ~ species) print $0}' ~/Workspace/Merging/Reworked.txt >> ${SPECIES}"AllCR1s.bed"

done <"/home/a1194388/Scripts/genomes.txt"

# Get FASTA of repeats for each species
while read SPECIES GENOME
do
        cd ~/Workspace/Merging/${SPECIES}

        bedtools getfasta -name -s -fi ~/Genomes/${SPECIES}/*.fasta -bed ${SPECIES}"AllCR1s.bed" -fo ${SPECIES}"AllCR1s.fasta"

        cat ${SPECIES}"AllCR1s.fasta" >> ~/Workspace/Merging/AllCR1s.fasta

done <"/home/a1194388/Scripts/genomes.txt"
