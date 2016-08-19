#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 16
#SBATCH --time=2-00:00
#SBATCH --mem=32GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au


module load BLAST+/2.2.31-foss-2015b-Python-2.7.11


cd ~/Clustering/blastdb/AllSpecies

echo starting blastn $i; date

blastn -query ~/Clustering/blastdb/AllSpecies/Queries/"AllSpeciesCR1s"$i".fasta" -task blastn -db AllSpeciesCR1s.db -out ~/Clustering/blastdb/AllSpecies/Results/"AllCR1s-blastn-"$i -outfmt 6 -num_threads 15

echo completed blastn $i; date
