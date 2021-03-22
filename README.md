# Project

I needed to analyze mouse exome (DNAseq) data, but had trouble getting the pipelines from the old HPC to work on HPC3.
The hardest part was rewriting the parallelization part -- making array jobs work.
This part didn't work until I got the templates from this class. 
Second hardest was rewriting all the human parts and making them mouse. 
Until this course I didn't know that recalibration in the GATK pipeline was only relevant for human data; so I cut it out.

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
 
