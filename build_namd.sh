#! /bin/bash -l

if [ ! -e namd ]; then
    echo "[SCVL] namd not found, attempting download"
    . download_namd.sh
fi

module unload cuda
cd namd
echo $CUDA_HOME

#compile charm++
cd charm-v7.0.0
./build charm++ multicore-linux-x86_64 --with-production
#./build charm++ netlrts-linux-x86_64 --with-production
#./build charm++ verbs-linux-x86_64 --with-production
#./build charm++ ucx-linux-x86_64 ompipmix --with-productionls
cd ..

module load cuda
./config Linux-x86_64-g++ --charm-arch multicore-linux-x86_64 --with-single-node-cuda --cuda-prefix $CUDA_HOME


cd Linux-x86_64-g++

make

mv namd3 ../../namd-bin/selfcompiled/namd3
