#! /bin/bash

# Version 3.0b7
# url="https://www.ks.uiuc.edu/Research/namd/3.0/download/342056/"
# Version 3.0.1
url="https://www.ks.uiuc.edu/Research/namd/3.0.1/download/453167/"
bins="multicore multicore-AVX512 multicore-CUDA netlrts-smp netlrts-smp-CUDA verbs-smp verbs-smp-CUDA"

download_namd() {
    # fullnamd="NAMD_3.0_Linux-x86_64-$1"
    fullnamd="NAMD_3.0.1_Linux-x86_64-$1"
    tarball=$fullnamd.tar.gz

    wget "$url/$tarball"
    tar xvzf $tarball
    rm -f $tarball
    mv $fullnamd namd-bin/precompiled/$1

    echo "[FAUcet] done downloading and extracting $namd"
}

find namd-bin/precompiled/* ! -name '.gitkeep' -type d -exec rm -rf {} +

# initiate downloads
for namd in $bins
do
    rm -f namd-bin/precompiled/$sync.sync
    download_namd $namd &
done

wait
echo "[FAUcet] downloaded and extracted all archives!"
