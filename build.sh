#! /bin/bash -l

#################
# CONFIGURATION #
#################

## compiler flags for clang ##
CLANGFLAGS="-O3 -march=native -mtune=native -m64 -Wl,-z,max-page-size=0x1000 -falign-functions=32 -ffast-math" # warns about linker flags during compilation, this is normal as they are only applied at the end

## compiler flags for icx namd ##
ICXFLAGS="-O3 -fp-model fast -xHost -unroll -vec-threshold1" # -ipo causes linking errors, vec-threshold tunable between 0-100

## gpu acceleration ##
# WITHGPU="--with-cuda" # gpuoff NVIDIA
WITHGPU="--with-single-node-cuda" # gpures NVIDIA
# WITHGPU="--with-hip" # gpuoff AMD
# WITHGPU="--with-single-node-hip" # gpures AMD

## fftw3 compiler ##
FFTWCC=icx

#################

# g++ seems to perform better than the icx version on cpu, latter gives warning about not being able to vectorize certain loops
# for gpu, icx seems to perform ~0.4% better :)

# TODO: Linux-AVX512-g++/clang++/icx
# TODO: optional multinode support, though we probably won't use it

if [ ! -d namd-src ]; then
    echo "[FAUcet] namd source folder missing, try running ./download_src.sh first"
    exit 1
fi

set -x

# TODO: replace with `module load xyz`
source /opt/intel/oneapi/setvars.sh

echo cd into src dir
cd namd-src

echo extract charm
tar xf charm-8.0.0.tar

echo build charm
cd charm-8.0.0
./build charm++ multicore-linux-x86_64 -j24 --with-production & # singlenode
./build charm++ multicore-linux-x86_64 icx -j24 --with-production & # singlenode-intel
./build charm++ mpi-linux-x86_64 mpicxx -j24 --with-production & # multinode-mpi
wait
cd ..

cd fftw-3.3.10
for compiler in gcc clang icx
do
    mkdir ../fftw3-$compiler
    mkdir ../fftw3-$compiler-avx512
    # AVX2
    ./configure --prefix $(pwd)/FAUcet-$compiler --enable-single --enable-avx2 --enable-fma CC=$compiler
    make -j32
    make install
    cp -r FAUcet-$compiler/include ../fftw3-$compiler
    cp -r FAUcet/lib ../fftw3-$compiler
    # AVX512
    ./configure --prefix $(pwd)/FAUcet-$compiler-avx512 --enable-single --enable-avx2 --enable-avx512 --enable-fma CC=$compiler
    make -j32
    make install
    cp -r FAUcet-$compiler-avx512/include ../fftw3-$compiler-avx512
    cp -r FAUcet-$compiler-avx512/lib ../fftw3-$compiler-avx512
done
cd ..

echo build namd
# hotfix for `register` modifier, deprecated for c++11 with icx
find src/ -type f | xargs sed -i -e 's/\tregister /\t/g' -e 's/ register / /g' -e 's/(register /(/g'

# standard AVX2 clang build
rm -rf Linux-x86_64-clang++/
./config Linux-x86_64-g++ --arch-suffix FAUcet --charm-arch multicore-linux-x86_64 --with-fftw3 --fftw-prefix `pwd`/fftw3-clang --tcl-prefix `pwd`/tcl-threaded --cxx clang++ --cc clang --cxx-opts "$CLANGFLAGS" --cc-opts "$CLANGFLAGS" $WITHGPU
mv Linux-x86_64-g++ Linux-x86_64-clang++
cd Linux-x86_64-clang++/
make -j32
cp namd3 ../../namd-bin/selfcompiled/namd3-clang-avx2-cuda
cd ..

# standard AVX2 g++ build
rm -rf Linux-x86_64-g++/
./config Linux-x86_64-g++ --arch-suffix FAUcet --charm-arch multicore-linux-x86_64 --with-fftw3 --fftw-prefix `pwd`/fftw3-gcc --tcl-prefix `pwd`/tcl-threaded $WITHGPU
cd Linux-x86_64-g++/
make -j32
cp namd3 ../../namd-bin/selfcompiled/namd3-gcc-avx2-cuda
cd ..

# icx AVX2
rm -rf Linux-x86_64-icx
./config Linux-x86_64-icx --arch-suffix FAUcet --charm-arch multicore-linux-x86_64-icx --with-fftw3 --fftw-prefix `pwd`/fftw3-icx --tcl-prefix `pwd`/tcl-threaded --cxx icx --cc icx --cxx-opts "$ICXFLAGS" --cc-opts "$ICXFLAGS" $WITHGPU
cd Linux-x86_64-icx
make -j32
cp namd3 ../../namd-bin/selfcompiled/namd3-icx-avx2
cd ..
