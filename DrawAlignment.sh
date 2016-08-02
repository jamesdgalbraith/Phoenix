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

module load Java/1.8.0_71

while read "name"
do

	java -cp ~/Workspace/gepard/dist/Gepard-1.40.jar org.gepard.client.cmdline.CommandLine -seq1 ~/Workspace/Cluster/AlignmentFASTAs/${name} -seq2 ~/Workspace/Cluster/AlignmentFASTAs/${name} -matrix ~/Workspace/gepard/resources/matrices/edna.mat -outfile ~/Workspace/Cluster/AlignmentPNGs/${name}.png

done <"/home/a1194388/Workspace/Cluster/repeatfilenames"
