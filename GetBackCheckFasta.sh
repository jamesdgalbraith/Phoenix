#!/bin/bash

# Used on Mac to pull members of families with id>0.90 and over 400bp
# Resulting sequences assumed to be fragments of family and will be blasted against other repeats to check
# if they do most closely match this family and if any others match closely

mkdir -p ~/Workspace/Clustering/silixall/0.80Families/Censored/524/BackCheck

while read SPECIES GENOME; do

cd ~/Workspace/Clustering/silixall/0.80Families/Censored/524/${SPECIES}

	awk '{if ($7>0.9 && $3-$2>400) print $1 "\t" $2 "\t" $3 "\t" $1 ":" $2 "-" $3 "(" $6 ")" "\t" 1 "\t" $6}' ~/Workspace/Clustering/silixall/0.80Families/Censored/524/${SPECIES}/$SPECIES".bed" > ~/Workspace/Clustering/silixall/0.80Families/Censored/524/BackCheck/${SPECIES}"_search.bed"

done<"/Users/jamesgalbraith/Scripts/genomes.txt"

cd ~/Workspace/Clustering/silixall/0.80Families/Censored/524/BackCheck

find . -empty -print0 | xargs -0 rm
ls *.bed | gsed 's/_search\.bed//' > genomes.txt


while read SPECIES; do
	
	bedtools getfasta -s -name -fi ~/Genomes/$SPECIES/*.fasta -bed ${SPECIES}_search.bed -fo ${SPECIES}_524_search.fasta

done<"genomes.txt"
