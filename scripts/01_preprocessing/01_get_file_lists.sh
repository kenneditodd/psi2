#!/bin/bash

# Get fastq file list
# There are 2 fastq files per sample
cd /research/labs/neurology/fryer/projects/psilocybin/psi2
out=/research/labs/neurology/fryer/m214960/psi2/refs/fastq_file_list.txt
ls -1 | grep .fastq.gz > $out

# Get sample file list
out=/research/labs/neurology/fryer/m214960/psi2/refs/sample_file_list.txt
ls -1 | grep _R1 > $out
