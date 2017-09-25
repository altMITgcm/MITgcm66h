#!/bin/bash
#
source ~/.bashrc
module load mpi/mpich-x86_64
mpirun --host c7-n001,c7-n002 -np 2 hostname
