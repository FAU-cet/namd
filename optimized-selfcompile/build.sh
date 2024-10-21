#! /usr/bin/env bash

# TODO: CUDA support
# TODO: optional multinode support, though we probably won't use it

set -x

# TODO: replace with `module load xyz`
source /opt/intel/oneapi/setvars.sh

echo cd into src dir
cd namd-src

echo extract charm
tar xf charm-8.0.0.tar

echo build charm
cd charm-8.0.0
./build charm++ multicore-linux-x86_64 -j32 --with-production # singlenode
./build charm++ multicore-linux-x86_64 icx -j32 --with-production # singlenode-intel
./build charm++ mpi-linux-x86_64 mpicxx -j32 --with-production # multinode-mpi
cd ..

echo get fftw
wget https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz
mkdir fftw
cd fftw-3.3.10
# TODO: AVX512
./configure --prefix $(pwd)/FAUcet --enable-single --enable-avx2 --enable-fma CC=icx
make -j32
make install
cp -r FAUcet/include ../fftw
cp -r FAUcet/lib ../fftw
cd ..

echo get tcl
wget https://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64-threaded.tar.gz
tar xzf tcl8.6.13-linux-x86_64-threaded.tar.gz
mv tcl8.6.13-linux-x86_64-threaded tcl-threaded

# g++ seems to perform better than the icx version, latter gives warning about not being able to vectorize certain loops
# TODO: Linux-AVX512-g++/clang++/icx
echo build namd
find src/ -type f | xargs sed -i -e 's/\tregister /\t/g' -e 's/ register / /g' -e 's/(register /(/g'
./config Linux-x86_64-g++ --arch-suffix FAUcet --charm-arch multicore-linux-x86_64 --with-fftw3 --tcl-prefix `pwd`/tcl-threaded
# ./config Linux-x86_64-icx --arch-suffix FAUcet --charm-arch multicore-linux-x86_64-icx --with-fftw3 --tcl-prefix `pwd`/tcl-threaded --cxx icpx --cc icx #--cxx-opts "-O3 -xHost -g0 -m64 -Wl,-z,max-page-size=0x1000 -falign-functions=32 -gz"
# ./config Linux-x86_64-icx --charm-arch multicore-linux-x86_64-icx --with-fftw3 --tcl-prefix `pwd`/tcl-threaded --cxx icpx --cxx-opts "-O3 -xHost -g1 -m64 -Wl,-z,max-page-size=0x1000 -falign-functions=32 -gz" --with-cuda
cd Linux-x86_64-g++/
# cd Linux-x86_64-icx/
make -j32
mv namd3 ../..
