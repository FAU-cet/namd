#! /bin/bash

# a.gpus n.cores-per-non-pme n.cores-per-pme
# -> gpus n.cores n.pmecores

gpuString=""
for k in $( seq 0 $1);
do
    gpuString="${gpuString},${k}"
done
gpuString=${gpuNumbers#*,}


additionalGPUs=$1
nonPmeCores=$2
pmeCores=$3
cpuCores=$((additionalGPUs*nonPmeCores))
cpuCores=$((cpuCores+pmeCores))


CORES=$(nproc)
if[$COREST -ge $cpuCores]; then
    sbatch -J namd-"$additionalGPUs"gpu-"$cpuCores"core-pme"$pmeCores" sbatch.sh $gpuString $cpuCores $pmeCores
fi

