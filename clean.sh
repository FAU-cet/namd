#! /bin/bash

rm -rf namd-src
echo "[FAUcet] cleaned namd-src"

for folder in benchmarks namd-bin/precompiled
do
    find $folder/* ! -name '.gitkeep' -type d -exec rm -rf {} +
    echo "[FAUcet] cleaned $folder"
done
