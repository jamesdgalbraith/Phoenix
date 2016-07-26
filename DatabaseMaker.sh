#!/bin/bash

module load BLAST+/2.2.31-foss-2015b-Python-2.7.11

while read SPECIES GENOME
do
  cd /home/a1194388/InitialRun/Cluster/Refined/silix/Databases
  mkdir -p $SPECIES
  cd $SPECIES

  makeblastdb -in /home/a1194388/InitialRun/Cluster/Refined/Queries/${SPECIES}/${SPECIES}'_Refined.fasta' -parse_seqids -dbtype nucl -out /home/a1194388/InitialRun/Cluster/Databases/${SPECIES}/${SPECIES}'_Database'

done <"/home/a1194388/Scripts/genomes.txt"
