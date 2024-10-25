#! /bin/bash -l

srcdir="./namd-src"

if [ -d $srcdir ]; then
    echo "[FAUcet] Source dir already exists, wipe? [y,N]"
    read input
    if [[  -n $input && $input == "y" ]]; then
        rm -rf $srcdir
    else
        exit 1
    fi
fi

echo "[FAUcet] get namd"
tarname="NAMD_3.0.1_Source"
url="https://www.ks.uiuc.edu/Research/namd/3.0.1/download/453167/$tarname.tar.gz"
wget $url
tar xzf $tarname.tar.gz
rm $tarname.tar.gz
mv $tarname $srcdir

cd $srcdir

echo "[FAUcet] get fftw"
wget https://www.fftw.org/fftw-3.3.10.tar.gz
tar xzf fftw-3.3.10.tar.gz

echo "[FAUcet] get tcl"
wget https://www.ks.uiuc.edu/Research/namd/libraries/tcl8.6.13-linux-x86_64-threaded.tar.gz
tar xzf tcl8.6.13-linux-x86_64-threaded.tar.gz
mv tcl8.6.13-linux-x86_64-threaded tcl-threaded

echo "[FAUcet] done"
