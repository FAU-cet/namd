#! /usr/bin/env bash

srcdir="./namd-src"

if [ -d $srcdir ]; then
    echo "Source dir already exists, wipe? [y,N]"
    read input
    if [[  -n $input && $input == "y" ]]; then
        rm -rf $srcdir
    else
        exit 1
    fi
fi

tarname="NAMD_3.0.1_Source"
url="https://www.ks.uiuc.edu/Research/namd/3.0.1/download/453167/$tarname.tar.gz"
wget $url
tar xzf $tarname.tar.gz
rm $tarname.tar.gz
mv $tarname $srcdir
