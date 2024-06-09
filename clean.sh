#! /bin/bash

rm -rf namd
echo "[FAUcet] cleaned namd folder"

for folder in benchmarks namd-bin/precompiled
do
    find $folder/* ! -name '.gitkeep' -type d -exec rm -rf {} +
    echo "[FAUcet] cleaned $folder"
done
