#!/bin/bash

# Example usage:
# GENOME=Chrysemys_picta_bellii STARTVALUE=1 ENDVALUE=125 sbatch lastz.sh

#SBATCH -p batch
#SBATCH -N 1 
#SBATCH -n 8 
#SBATCH --time=12:00:00 
#SBATCH --mem=64GB 

# Notification configuration 
#SBATCH --mail-type=END                                         
#SBATCH --mail-type=FAIL                                        
#SBATCH --mail-user=james.galbraith@student.adelaide.edu.au 

# Load the necessary modules
module load gnu-parallel/2016-01-23-foss-2015b
module load BEDTools/2.25.0-foss-2015b


# LASTZ
        # In Results directory, make a new directory for your genome
        mkdir -p ~/RunFamilyChecks/$FAMILY/Lastz/Results/${GENOME}
        cd ~/RunFamilyChecks/$FAMILY/Lastz/Results/${GENOME}
        mkdir -p Hits
        mkdir -p FASTA
        cd Hits

        # Print species name
        echo ${GENOME}

        # Align CR1 query seqs to all Genome seqs, using LASTZ
        # Note that this currently points to the Split_seqs genome sub-directory
        # (which assumes that you've already run split.sh)
        seq ${STARTVALUE} ${ENDVALUE} | parallel lastz '~/Genomes/'${GENOME}'/Split_seqs/seq{}.fa[unmask,multiple] ~/Clustering/Families/'$FAMILY'/'$FAMILY'.fasta[unmask,multiple] --chain --gapped --identity=80 --coverage=80  --ambiguous=n --ambiguous=iupac --format=general-:name2,start2,end2,score,strand2,size2,name1,start1,end1 > ~/RunFamilyChecks/'$FAMILY'/Lastz/Results/'${GENOME}'/Hits/LASTZ_CR1_'${GENOME}'_seq{}'

        # Make sure you are in the right directory
        cd ~/RunFamilyChecks/$FAMILY/Lastz/Results/${GENOME}/Hits

        # Remove all files that are empty
        find -size  0 -print0 | xargs -0 rm

        # Concatenate all hit files into one file
        cat 'LASTZ_CR1_'${GENOME}'_seq'* > 'LASTZ_CR1_'${GENOME}'_AllSeqs'

        # Rearrange columns to put the concatenated file in BED-like form (for BEDTools) 
        awk '{print $7 "\t" $8 "\t" $9 "\t" $1 "\t" "1" "\t" $5}' 'LASTZ_CR1_'${GENOME}'_AllSeqs' >> 'BedFormat_CR1_'${GENOME}'_AllSeqs'

        # Sort by chr/scaffold and then by start position in ascending order 
        bedtools sort -i 'BedFormat_CR1_'${GENOME}'_AllSeqs' > 'Sorted_CR1_'${GENOME}'_AllSeqs'

        # Merge nested or overlapping intervals
        bedtools merge -s -i 'Sorted_CR1_'${GENOME}'_AllSeqs' -c 4 -o collapse > 'Merged_CR1_'${GENOME}'_AllSeqs'

        # Merging broke the BED-like format
        # (i.e. strand is now in 4th column, merged names in 5th column, etc)
        # Rearrange the columns as required
        awk '{print $1 "\t" $2 "\t" $3 "\t" $5 "\t" "1" "\t" $4}' 'Merged_CR1_'${GENOME}'_AllSeqs' >> 'Merged_CR1_'${GENOME}'_AllSeqs_proper.bed'

        # Extract FASTA from corrected merged BED file
        # Note that (for simplicity) this uses the whole genome file, not the Split_seqs
        bedtools getfasta -s -fi ~/Genomes/${GENOME}/*.fasta -bed 'Merged_CR1_'${GENOME}'_AllSeqs_proper.bed' -fo results.fasta

        # Sort sequences by length
        usearch -sortbylength results.fasta -fastaout ${GENOME}'_CR1_AllSeqs.fasta'
