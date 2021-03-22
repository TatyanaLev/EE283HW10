#!/bin/bash

#SBATCH --job-name=bigwig
#SBATCH -A ecoevo283                  ## account to charge
#SBATCH -p standard                   ## standard partition
#SBATCH -N 1                          ## nodes
#SBATCH --array=1-5                    ## tasks
#SBATCH -c 2                          ## CPUs
#SBATCH -t 1-                         ## day run time limit


##############################
## DO BEFORE RUNNING SCRIPT ##
##############################
#cat $ref.fai | head -n 66 | awk '{printf("%s\t0\t%s\n",$1,$2)}' > major.bed

module load samtools/1.10
module load ucsc-tools/v393 
module load bedtools2/2.29.2

ref="/dfs6/pub/tzhuravl/LawsonRotation/mm10/mm10_genome.fa"
file="/data/class/ecoevo283/tzhuravl/scripts/EE283HW10/bams_list.txt"
bam=`head -n $SLURM_ARRAY_TASK_ID  ${file} | tail -n 1`

path="/data/class/ecoevo283/tzhuravl/scripts/EE283HW10"

cd $path


samtools view -b -L major.bed $bam > $bam.maj

Nreads=`samtools view -c -F 4 $bam.maj`

Scale=`echo "1.0/($Nreads/1000000)" | bc -l`

samtools view -b $bam.maj | genomeCoverageBed -bg -scale $Scale -ibam - > $bam.coverage

bedSort $bam.coverage $bam.sort.coverage

bedGraphToBigWig $bam.sort.coverage $ref.fai $bam.bw
