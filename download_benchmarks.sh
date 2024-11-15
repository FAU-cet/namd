#! /bin/sh

# benchmarks
benchs="dhfr apoa1 stmv"

download_bench() {
    ORIGINAL="$1"_gpu
    ARCHIVE=$ORIGINAL.tar.gz
    DIR="benchmarks/$1"

    wget https://www.ks.uiuc.edu/Research/namd/benchmarks/systems/$ARCHIVE
    tar xvzf $ARCHIVE
    rm -f $ARCHIVE
    mv $ORIGINAL $DIR

    echo "[FAUcet] done downloading and extracting $1"
}

find benchmarks/* ! -name '.gitkeep' -type d -exec rm -rf {} +

# initiate downloads
for bench in $benchs
do
    rm -f benchmarks/$bench.sync
    download_bench $bench &
done

wait
echo "[FAUcet] downloaded and extracted all archives!"
