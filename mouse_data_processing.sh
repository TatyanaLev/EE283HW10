#!/bin/bash
#SBATCH --job-name=alignDNA
#SBATCH -A ecoevo283
#SBATCH -p standard
#SBATCH --nodes=1
#SBATCH --array=1-5
#SBATCH --cpus-per-task=3    ## number of cores the job needs
#SBATCH --output=alignDNA-%J.out
#SBATCH --error=alignDNA-%J.err


cd /dfs6/pub/tzhuravl/mouseWES/

module load samtools
module load bwa
module load java
module load picard-tools/1.87
module load gatk


path1='/dfs6/pub/tzhuravl/mouseWES/'

file1=${path1}r1_list.txt
file2=${path1}r2_list.txt

name1=`head -n $SLURM_ARRAY_TASK_ID $file1 | tail -n 1`
name2=`head -n $SLURM_ARRAY_TASK_ID $file2 | tail -n 1`

read1='.r1.fastq'
read2='.r2.fastq'
samext='.sam'
bamext='.bam'
baiext='.bai'
textext='.txt'
statext='.mh.chr_stat.txt'
astatext='.mh.all_stat.txt'
hstatext='.h.chr_stat.txt'
hastatext='.h.all_stat.txt'
table='.table'
ptable='.post.table'
vcfext='.raw_variants.vcf'
reord='reordered_'
sort='sorted_'
dup='duplicates_marked_'
filter='filtered_'
recal='recalibrated_'
proper='proper_'
unpair='unpaired_'

readgroupinfo='@RG\tID:EGA\tSM:'${name1}'\tPL:Illumina'


dir=${name1//.fastq/}
mkdir $path1$dir
back='/'
path=$path1$dir$back


bwa mem -M -t 18 -R $readgroupinfo '/dfs6/pub/tzhuravl/LawsonRotation/mm10/mm10_genome.fa' $path1$name1 $path1$name2 > $path$name1$samext

samtools view -bS $path$name1$samext > $path$name1$bamext

#extract properly paired reads
samtools view -f 0x2 -b $path$name1$bamext > $path$proper$name1$bamext

#quality filter reads
samtools view -b -q 40 $path$name1$samext > $path$filter$name1$samext

samtools view -bS $path$filter$name1$samext > $path$filter$name1$bamext

#sort bam by coordinates
java -Xmx3g -jar /opt/apps/picard-tools/1.87/SortSam.jar I=$path$filter$name1$bamext O=$path$sort$filter$name1$bamext SORT_ORDER=coordinate

#reorder bam to match mm10
java -Xmx3g -jar /opt/apps/picard-tools/1.87/ReorderSam.jar I=$path$sort$filter$name1$bamext O=$path$reord$sort$filter$name1$bamext R=/dfs6/pub/tzhuravl/LawsonRotation/mm10/mm10_genome.fa

#remove duplicates
java -Xmx3g -jar /opt/apps/picard-tools/1.87/MarkDuplicates.jar INPUT=$path$reord$sort$filter$name1$bamext OUTPUT=$path$dup$reord$sort$filter$name1$bamext CREATE_INDEX=true METRICS_FILE=$path$dup$reord$sort$filter$name1$textext

#find all stats
samtools stats $path$dup$reord$sort$filter$name1$bamext > $path$dup$reord$sort$filter$name1$hastatext


rm $path$name1$samext $path$name1$bamext $path$proper$name1$bamext $path$filter$name1$samext $path$filter$name1$bamext $path$sort$filter$name1$bamext $path$reord$sort$filter$name1$bamext 

