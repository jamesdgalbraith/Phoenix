#!/bin/bash

#SBATCH -p batch
#SBATCH -N 1
#SBATCH -n 4
#SBATCH --time=1:00:00
#SBATCH --mem=32GB

# notification configuration
#SBATCH --mail-type=END
#SBATCH --mail-type=FAIL
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au

cd ~/Workspace/Cluster/AlignmentFASTAs/

for f in *.fasta; do
    d="$(head -1 "$f" | sed 's/(+)/_fwd/' | sed 's/(-)/_rev/' | sed 's/>//' | awk '{print $1}').fasta"
    if [ ! -f "$d" ]; then
        mv "$f" "$d"
    else
        echo "File '$d' already exists! Skipped '$f'"
    fi
done
