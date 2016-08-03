#!/bin/bash

# Using gepard constructs self-alignment pngs of sequences
# 



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

        # -seq1 and seq2  are the path to the sequence, -matrix the path to the matrix and -outfile the location for the constructed png 
        java -cp ~/Workspace/gepard/dist/Gepard-1.40.jar org.gepard.client.cmdline.CommandLine -seq1 ~/Workspace/Cluster/AlignmentFASTAs/${name} -seq2 ~/Workspace/Cluster/AlignmentFASTAs/${name} -matrix ~/Workspace/gepard/resources/matrices/edna.mat -outfile ~/Workspace/Cluster/AlignmentPNGs6/${name}6.png -word 6
        java -cp ~/Workspace/gepard/dist/Gepard-1.40.jar org.gepard.client.cmdline.CommandLine -seq1 ~/Workspace/Cluster/AlignmentFASTAs/${name} -seq2 ~/Workspace/Cluster/AlignmentFASTAs/${name} -matrix ~/Workspace/gepard/resources/matrices/edna.mat -outfile ~/Workspace/Cluster/AlignmentPNGs9/${name}9.png -word 9

done <"/home/a1194388/Workspace/Cluster/FASTANames.txt"
