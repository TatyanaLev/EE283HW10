#!/bin/bash

#SBATCH --job-name=index_genome       ## Name of the job.
#SBATCH -A ecoevo283                  ## account to charge
#SBATCH -p standard                   ## standard partition
#SBATCH -N 1                          ## nodes
#SBATCH -n 1                          ## tasks
#SBATCH -c 1                          ## CPUs
#SBATCH -t 1-                         ## day run time limit
#SBATCH --error=slurm-%J.err


module load bwa 
module load samtools
module load java
module load picard-tools/1.87
module load gatk
module load hisat2

ref="/dfs6/pub/tzhuravl/LawsonRotation/mm10/mm10_genome.fa"

bwa index $ref
samtools faidx $ref
java -Xmx128g -jar /opt/apps/picard-tools/1.87/CreateSequenceDictionary.jar R=$ref O=dmel-all-chromosome-r6.13.dict
hisat2-build $ref $ref
