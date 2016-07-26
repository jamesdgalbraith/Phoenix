# Queues censor runs for all species

while read SPECIES GENOME
do
SPECIES=${SPECIES} sbatch RunCensor.sh
done <"/home/a1194388/Scripts/genomes.txt"
