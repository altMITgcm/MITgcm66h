
#!/bin/csh
# invoking mpirun at AERs Linux cluster beehive
#
cd /cluster/scratch/month01/heimbach/ecco-branch/exe
/opt/mpich/bin/mpirun.ch_gm -np 6 --gm-v ./mitgcmuv
exit
