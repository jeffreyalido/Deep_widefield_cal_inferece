#!/bin/bash

# template sh file

for idx in 1 2 3 4 5 6 7
do
  qsub -v idx=$idx -N idx_${idx} -o idx_${idx} qsub1.qsub
done