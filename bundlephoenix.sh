#!/bin/bash

# Example usage:
# sbatch bundlephoenix.sh

#SBATCH -p batch
#SBATCH -N 1 
#SBATCH -n 8 
#SBATCH --time=1-00:00 
#SBATCH --mem=32GB 

# Notification configuration 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au 

# Load the necessary modules
module load gnu-parallel/2016-01-23-foss-2015b


# Go run bundle on unbundled genomes
cd ~/test_lastz/Genomes/$SPECIES
parallel bundle -in {} ::: *.fa
