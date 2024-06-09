#! /bin/bash

# Version 3.0b7
url="https://www.ks.uiuc.edu/Research/namd/3.0b7/download/231945/"
bins="multicore multicore-AVX512 multicore-CUDA netlrts-smp netlrts-smp-CUDA verbs-smp verbs-smp-CUDA"

download_namd() {
    fullnamd="NAMD_3.0b7_Linux-x86_64-$1"
    tarball=$fullnamd.tar.gz

    wget "$url/$tarball"
    tar xvzf $tarball
    rm -f $tarball
    mv $fullnamd namd-bin/precompiled/$1

    echo "[FAUcet] done downloading and extracting $namd"
    touch namd-bin/precompiled/$1.sync
}

find namd-bin/precompiled/* ! -name '.gitkeep' -type d -exec rm -rf {} +

# initiate downloads
for namd in $bins
do
    rm -f namd-bin/precompiled/$sync.sync
    download_namd $namd &
done

# wait for everything to download
for sync in $bins
do
    while [ ! -e namd-bin/precompiled/$sync.sync ]
    do
        sleep 1
    done
    rm namd-bin/precompiled/$sync.sync
done

echo "[FAUcet] downloaded and extracted all archives!"
