#!/bin/bash

# template sh file

timestamp=$(date +"%Y%m%d%H%M%S%N")  # %N for nanoseconds
for idx in 1 2 3 4 5 6 7
do
  qsub -v idx=$idx -o /projectnb/tianlabdl/caragon/log/job_${timestamp}_${idx} -N idx_${idx} qsub1.qsub
done