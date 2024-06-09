#! /bin/sh


#download the latest binarys for namd from the repos and exit if no access is available
rm -rf namd
git clone git@gitlab.com:tcbgUIUC/namd.git
if [ ! -d namd ]; then
	echo need ssh access to the namd repository
	exit 1
fi

cd namd


#import charm++
git clone https://github.com/UIUC-PPL/charm
mv charm charm-v7.0.0

#download the other necessary binaries
wget http://www.ks.uiuc.edu/Research/namd/libraries/fftw-linux-x86_64.tar.gz
wget http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64.tar.gz
wget http://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64-threaded.tar.gz

tar xzf fftw-linux-x86_64.tar.gz
tar xzf tcl8.6.13-linux-x86_64.tar.gz
tar xzf tcl8.6.13-linux-x86_64-threaded.tar.gz

rm *.tar.gz

mv linux-x86_64 fftw
mv tcl8.6.13-linux-x86_64 tcl
mv tcl8.6.13-linux-x86_64-threaded tcl-threaded


#module load cuda
#./config Linux-x86_64-g++ --charm-arch multicore-linux-x86_64 --with-single-node-cuda --cuda-prefix $CUDA_HOME

#mkdir bin

#cd Linux-x86_64-g++

#make

#mv namd3 ../bin
