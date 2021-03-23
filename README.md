# Project - mouse exome 

I needed to analyze mouse exome (DNAseq) data, but had trouble getting the pipelines from the old HPC to work on HPC3.
The hardest part was rewriting the parallelization part -- making array jobs work.
This part didn't work until I got the templates from this class. 
Second hardest was rewriting all the human parts and making them mouse. 
Until this course I didn't know that recalibration in the GATK pipeline was only relevant for human data; so I cut it out.

## My samples

4 tumor quarters and 1 normal blood reference.

Blood: P001-GACGTAAG-GGCTTGGC

Tumor chunks: 

P002-AGGCCTGA-TGACCGAG, 
P003-TAAGATTA-AGCCTGCG, 
P004-AGGCGAAT-GAGGACGC, 
P005-TTGTTCTT-ACTTGTAG

## Indexing the mm10 mouse genome
```{bash}
(base) [tzhuravl@login-i16:/dfs6/pub/tzhuravl/LawsonRotation/mm10] $ls -lah | tail
-rw-rw-r--  1 tzhuravl tzhuravl 8.5K Mar  4 13:38 mm10_genome.dict
-rwxr-xr-x  1 tzhuravl tzhuravl 2.6G Oct  3  2019 mm10_genome.fa
-rw-rw-r--  1 tzhuravl tzhuravl  11K Mar  4 05:56 mm10_genome.fa.amb
-rw-rw-r--  1 tzhuravl tzhuravl 3.0K Mar  4 05:56 mm10_genome.fa.ann
-rw-rw-r--  1 tzhuravl tzhuravl 2.6G Mar  4 05:55 mm10_genome.fa.bwt
-rw-rw-r--  1 tzhuravl tzhuravl 2.6K Mar  4 06:07 mm10_genome.fa.fai
-rw-rw-r--  1 tzhuravl tzhuravl 652M Mar  4 05:56 mm10_genome.fa.pac
-rw-rw-r--  1 tzhuravl tzhuravl 1.3G Mar  4 06:06 mm10_genome.fa.sa
```

## Alignment

I aligned the samples to the mm10 genome version and did some additional processing steps like marking duplicates and ordering the bams by coordinates.

## Making bigwigs

As suggested by Dr. Long, I wanted to try finding copy number variants in the tumors by comparing the amount of pile-ups between the tumor and normal sample.
I made bigwig files to view in UCSC genome browser. Areas of CNV could be detected visually as bigger or smaller piles in the tumor compared to the reference. 
There are genes like Rb1 and Myc that frequently get CNV, so I would start there.

```{bash}
(base) [tzhuravl@login-i15:/data/class/ecoevo283/tzhuravl/scripts/EE283HW10] $ls -lah
total 27G
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta  525 Mar 21 21:39 bams_list.txt
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta  778 Mar 21 21:10 index_genome.sh
-rw-rw-r-- 1 tzhuravl tzhuravl           1.7K Mar 21 21:35 major.bed
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 1.2K Mar 21 21:40 make_bigwigs.sh
-rwxr-xr-x 1 tzhuravl tzhuravl           2.5K Mar 21 21:12 mouse_data_processing.sh
-rw-rw-r-- 1 tzhuravl tzhuravl           6.0M Mar  4 23:07 P001-GACGTAAG-GGCTTGGC.bai
-rw-rw-r-- 1 tzhuravl tzhuravl           2.0G Mar  4 23:07 P001-GACGTAAG-GGCTTGGC.bam
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 301M Mar 21 21:57 P001-GACGTAAG-GGCTTGGC.bam.bw
-rw-rw-r-- 1 tzhuravl tzhuravl           6.1M Mar  5 00:32 P002-AGGCCTGA-TGACCGAG.bai
-rw-rw-r-- 1 tzhuravl tzhuravl           2.6G Mar  5 00:32 P002-AGGCCTGA-TGACCGAG.bam
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 384M Mar 21 22:02 P002-AGGCCTGA-TGACCGAG.bam.bw
-rw-rw-r-- 1 tzhuravl tzhuravl           6.2M Mar  5 01:29 P003-TAAGATTA-AGCCTGCG.bai
-rw-rw-r-- 1 tzhuravl tzhuravl           2.8G Mar  5 01:29 P003-TAAGATTA-AGCCTGCG.bam
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 420M Mar 21 22:04 P003-TAAGATTA-AGCCTGCG.bam.bw
-rw-rw-r-- 1 tzhuravl tzhuravl           6.1M Mar  4 23:30 P004-AGGCGAAT-GAGGACGC.bai
-rw-rw-r-- 1 tzhuravl tzhuravl           2.6G Mar  4 23:30 P004-AGGCGAAT-GAGGACGC.bam
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 386M Mar 21 22:03 P004-AGGCGAAT-GAGGACGC.bam.bw
-rw-rw-r-- 1 tzhuravl tzhuravl           6.2M Mar  5 00:17 P005-TTGTTCTT-ACTTGTAG.bai
-rw-rw-r-- 1 tzhuravl tzhuravl           2.8G Mar  5 00:17 P005-TTGTTCTT-ACTTGTAG.bam
-rw-rw-r-- 1 tzhuravl class-ecoevo283-ta 406M Mar 21 22:05 P005-TTGTTCTT-ACTTGTAG.bam.bw
```

## Results

So something didn't go right. 
As you can see, each file reports "no data" for the entire chromosome (same thing when I zoom in). 
I don't know what went wrong; the script was basically the same as for _Drosophila_, just updated for mouse stuff...


![mouse_bigWigs.png](https://github.com/TatyanaLev/EE283HW10/blob/main/mouse_bigWigs.png)
