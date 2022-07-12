#!/bin/bash

. ./common.bash

ENGINES=${ENGINES:="wizard wasm3 wamr-fast jsc-int v8-liftoff jsc-bbq v8-turbofan jsc-omg"}

if [ $# != 0 ]; then
    BENCHMARKS=$@
fi

# Translation time
echo Translation time ratio
for engine in $ENGINES; do
    printf "\t%s" $engine
done
printf "\n"

for BENCHMARK in $BENCHMARKS; do
    printf "%s" $BENCHMARK
    
    for engine in $ENGINES; do
        DATAFILE=$DATA/translation.$BENCHMARK.$engine.us
        if [ -f $DATAFILE ]; then
            AVG=$(awk -f average.awk $DATAFILE)
            # convert microseconds per byte to nanoseconds per byte
            printf "\t%s" $(echo "scale=9;" 1000 \* $AVG | bc)
        else
            printf "\t--"
        fi
    done
    printf "\n"
done

# Translation bytes
echo Translation space ratio
for engine in $ENGINES; do
    printf "\t%s" $engine
done
printf "\n"

for BENCHMARK in $BENCHMARKS; do
    printf "%s" $BENCHMARK
    
    for engine in $ENGINES; do
        if [ -f $DATAFILE ]; then
            DATAFILE=$DATA/translation.$BENCHMARK.$engine.bytes
            AVG=$(awk -f average.awk $DATAFILE)
            printf "\t%s" $AVG
        else
            printf "\t--"
        fi
    done
    printf "\n"
done
