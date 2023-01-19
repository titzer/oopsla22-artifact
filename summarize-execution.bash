#!/bin/bash

. ./common.bash

ENGINES=${ENGINES:="v8-turbofan jsc-omg sm-opt jsc-bbq sm-base v8-liftoff wasm3 jsc-int wamr-fast wizard wamr-classic wizard-jit"}

if [ $# != 0 ]; then
    BENCHMARKS=$@
fi

# Execution time
echo Execution time
for engine in $ENGINES; do
    printf "\t%s" $engine
    if [ "$ERROR" != "" ]; then
        printf "\t%s(p5rel)\t%s(p95rel)" $engine $engine
    fi
done
printf "\n"

TMP=/tmp/summarize-execution.samples

for BENCHMARK in $BENCHMARKS; do
    printf "%s" $BENCHMARK
    
    for engine in $ENGINES; do
        DATAFILE=$DATA/execution.$BENCHMARK.$engine
        if [ "$ERROR" != "" ]; then
            if [ -f $DATAFILE ]; then
                rm -f $TMP.1
                for s in $(cat $DATAFILE); do
                    echo $s >> $TMP.1
                done
                grep -v = $TMP.1 > $TMP
                AVG=$(awk -f average.awk $TMP)
                P5=$(sort -n $TMP | awk -f p5.awk)
                P95=$(sort -n $TMP | awk -f p95.awk)
                #            echo "scale 6;" "($AVG - $P5) / $AVG"
                P5_rel=$(echo "scale=6;" "($AVG - $P5)"  | bc)
                P95_rel=$(echo "scale=6;" "($P95 - $AVG)"  | bc)
                printf "\t%s\t%s\t%s" $AVG $P5_rel $P95_rel
            else
                printf "\t--\t--\t--" $AVG $P5_rel $P95_rel
            fi
        else
            if [ -f $DATAFILE ]; then
                VAL=$(sed "-es/.*avg=\([0-9]*.[0-9]*\).*/\1/" $DATAFILE)
                printf "\t%s" $VAL
            else
                printf "\t--"
            fi
        fi
    done
    printf "\n"
done
