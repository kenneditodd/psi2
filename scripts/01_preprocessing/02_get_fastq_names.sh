#!/bin/bash

# go to data dir
cd /research/labs/neurology/fryer/projects/psilocybin/psi2

# get fastq list
out=/research/labs/neurology/fryer/m214960/psi2/refs/original_fastq_names.txt
ls -1 | grep .fastq.gz$ > $out
