#! /bin/sh

download_bench() {
        ORIGINAL="$1"_gpu
        ARCHIVE=$ORIGINAL.tar.gz
        DIR="$1".benchmark

        rm -rf $DIR
        wget https://www.ks.uiuc.edu/Research/namd/benchmarks/systems/$ARCHIVE
        tar xvf $ARCHIVE
        mv $ORIGINAL $DIR
        rm -f $ARCHIVE
}

for bench in dhfr apoa1 stmv
do
        download_bench $bench &
done
