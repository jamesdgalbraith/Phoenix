#!/bin/bash

while read SPECIES GENOME
do

cd /home/a1194388/InitialRun/Cluster/Refined
mkdir $SPECIES
cd $SPECIES

# to join files using 'join' they must be sorted
sort /home/a1194388/Genomes/$SPECIES/${GENOME}.fai > 'Sorted'${SPECIES}'Fai.txt'
sort /home/a1194388/InitialRun/Censor/FilteredResults/$SPECIES/${SPECIES}'_CR1.bed' > 'Sorted'${SPECIES}'Bed.txt'

# join the two files
join 'Sorted'${SPECIES}'Bed.txt' 'Sorted'${SPECIES}'Fai.txt' > 'Joined'${SPECIES}'.txt'

# filter out CR1s 20bp or less from the ends of contigs
sed 's/ /\t/g' 'Joined'${SPECIES}'.txt' | awk '{ if ($2>20 && $7-$3>20) print $1, $2, $3, $4, 5, 6 }' > ${SPECIES}'_Refined.bed'

# remove unnecessary files
rm 'Sorted'${SPECIES}'Fai.txt'
rm 'Sorted'${SPECIES}'Bed.txt'
rm 'Joined'${SPECIES}'.txt'

done <"/home/a1194388/Scripts/genomes.txt"
