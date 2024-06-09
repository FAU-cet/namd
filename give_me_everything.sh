#! /bin/bash

scripts="download_benchmarks.sh download_binaries.sh download_namd.sh"

run() {
    ./$1

    echo "[FAUcet] ran script $1"
    touch $1.sync
}

# launch rockets
for script in $scripts
do
    rm -f $script.sync
    run $script &
done

# wait for impact
for sync in $scripts
do
    while [ ! -e $sync.sync ]
    do
        sleep 1
    done
    rm $sync.sync
done

echo
echo "[蛇口] かわいい猫! 🐱🐱🐱"
