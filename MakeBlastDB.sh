#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=1-00:00
#SBATCH --mem=32GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au

module load BLAST+/2.2.31-foss-2015b-Python-2.7.11

cd ~/Clustering/blastdb/AllSpecies

echo started making blastdb; date

makeblastdb -in AllSpeciesCR1s.fasta -parse_seqids -dbtype nucl -out AllSpeciesCR1s.db

echo finished making blastdb; date
