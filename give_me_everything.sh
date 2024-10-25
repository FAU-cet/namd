#! /bin/bash

scripts="download_benchmarks.sh download_binaries.sh download_src.sh"

run() {
    ./$1

    echo "[FAUcet] ran script $1"
}

# launch rockets
for script in $scripts
do
    rm -f $script.sync
    run $script &
done

# wait for impact
wait
echo
echo "[蛇口🚰] かわいい猫 UwU! 🐱🐱🐱"
