#! /bin/bash -l
#
#SBATCH --nodes=1
#SBATCH --exclusive
#SBATCH --ntasks=1
#SBATCH --time=00:30:00
#SBATCH --gres=gpu:a100:8
#SBATCH --export=NONE

unset SLURM_EXPORT_ENV

if [ $1 != "0" ]; then
    PMEs="+pmepes $3"
fi

srun ../../namd3 +p$2 $PMEs +setcpuaffinity +devices $1 testdata/stmv_gpures_nve.namd
