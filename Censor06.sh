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

module load BEDTools/2.25.0-foss-2015b
module load bioperl/1.6.924
module load censor/4.2.29
module load wu-blast/2.0


# CENSOR
        # make directory for CENSOR output
        mkdir -p /home/a1194388/Run06/Censor/Results/${SPECIES}
        cd /home/a1194388/Run06/Censor/Results/${SPECIES}

        # run CENSOR
        echo ${SPECIES} Censor.sh
        censor -bprm cpus=8 -lib /home/a1194388/Scripts/RepBase21.03_all_seqs.ref /home/a1194388/Run06/Lastz/Results/${SPECIES}/Hits/${SPECIES}"_CR1_AllSeqs.fasta"



# Filtering CENSOR results and converting to .bed
        # make directory for filtering results
        mkdir -p /home/a1194388/Run06/Censor/FilteredResults/${SPECIES}
        cd /home/a1194388/Run06/Censor/FilteredResults/${SPECIES}

        cat /home/a1194388/Run06/Censor/Results/${SPECIES}/${SPECIES}*.map | awk '{if ($7=="d") print $0 }' | awk '{print $1 "\t" $4}' | sed 's/:/\t/g' | sed 's/(-)/.rev/g' | sed 's/(+)/.fwd/g' | awk '{gsub(/-/,"\t",$2); print}' | sed 's/.rev/\t-/g' | sed 's/.fwd/\t+/g' | awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" "1" "\t" $4}' > rearranged.map
        # want chr/scaff name, start coord, end coord, repbase id, dummy score, strand with respect to ref

        # sort the file by chr/scaffold then coordinates
        bedtools sort -i rearranged.map > sorted.map

        # merge overlapping hits
        bedtools merge -s -i sorted.map -c 4 -o collapse > merged.map

        # rearrange columns
        awk '{print $5 "\t" $1 "\t" $2 "\t" $3 "\t" $4}' merged.map >> merged.txt

        # extract sequences wqhich identified as L1s
        # download from Repbase all potential L1 sequences
        # e.g. everything in L1 group and Tx1 group (1826 seqs total)
        # extract all the header names -> 1826_L1_and_Tx1_repbase_headers.txt
        # compare this to the hit names in the merged.txt file
        # and then rearrange into BED format again
        awk 'NR==FNR { a[$1] = $1; next} { for (k in a) if ($1 ~ a[k]) { print $0; break } }' ~/Scripts/CR1Names.txt merged.txt | awk '{print $2 "\t" $3 "\t" $4 "\t" $1 "\t" "1" "\t" $5}' > ${SPECIES}_CR1.bed

        # Extract FASTA from L1-only merged BED file
        bedtools getfasta -s -fi /home/a1194388/Genomes/${SPECIES}/*.fasta -bed ${SPECIES}_CR1.bed -fo results.fasta

        # sort sequences by length
        usearch -sortbylength results.fasta -fastaout /home/a1194388/Run06/Censor/FilteredResults/${SPECIES}/${SPECIES}_CR1_Filtered.fasta

        # remove unnecessary files
        rm merged.map merged.txt rearranged.map results.fasta sorted.map

# Refining CENSOR to remove repeats closer than 100bp to the end of a contig
        cd /home/a1194388/Run06/Censor/Refined
        mkdir -p ${SPECIES}
        cd ${SPECIES}

        # to join files using 'join' they must be sorted
        sort /home/a1194388/Genomes/${SPECIES}/*.fai > 'Sorted'${SPECIES}'Fai.txt'
        sort /home/a1194388/Run06/Censor/FilteredResults/${SPECIES}/${SPECIES}'_CR1.bed' > 'Sorted'${SPECIES}'Bed.txt'

        # join the two files
        join 'Sorted'${SPECIES}'Bed.txt' 'Sorted'${SPECIES}'Fai.txt' > 'Joined'${SPECIES}'.txt'

        # filter out CR1s 100bp or less from the ends of contigs
        sed 's/ /\t/g' 'Joined'${SPECIES}'.txt' | awk '{ if ($2>100 && $7-$3>100) print $1 "\t" $2 "\t" $3 "\t" $4 "\t" $5 "\t" $6 }' > ${SPECIES}'_Refined.bed'

        # remove unnecessary files
        rm 'Sorted'${SPECIES}'Fai.txt'
        rm 'Sorted'${SPECIES}'Bed.txt'
        rm 'Joined'${SPECIES}'.txt'
