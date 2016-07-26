#!/bin/bash

#SBATCH --qos=debug
#SBATCH -N 1 
#SBATCH -n 4 
#SBATCH --time=4:00:00 
#SBATCH --mem=4GB 

# Notification configuration 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au

module load BLAST+/2.2.31-foss-2015b-Python-2.7.11


# used to run blast of repeats against a database of themselves

cd /home/a1194388/InitialRun/Cluster/Refined/silix/blastnClusters

while read SPECIES GENOME
do

blastn -db /home/a1194388/InitialRun/Cluster/Refined/silix/Databases/${SPECIES}/${SPECIES}'_Database' -query /home/a1194388/InitialRun/Cluster/Refined/Queries/${SPECIES}/${SPECIES}'_Refined.fasta' -outfmt 6 -out ${SPECIES}'_CR1_blast.out'

done <"/home/a1194388/Scripts/genomes.txt"
