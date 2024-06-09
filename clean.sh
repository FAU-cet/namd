#! /bin/bash

rm -rf namd
echo "[SCVL] cleaned namd folder"

for folder in benchmarks namd-bin/precompiled
do
    find $folder/* ! -name '.gitkeep' -type d -exec rm -rf {} +
    echo "[SCVL] cleaned $folder"
done
