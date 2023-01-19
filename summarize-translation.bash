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
    if [ "$ERROR" != "" ]; then
        printf "\t%s(p5rel)\t%s(p95rel)" $engine $engine
    fi
done
printf "\n"

TMP=/tmp/summarize-translation.samples

for BENCHMARK in $BENCHMARKS; do
    printf "%s" $BENCHMARK
    
    for engine in $ENGINES; do
        DATAFILE=$DATA/translation.$BENCHMARK.$engine.us
        if [ "$ERROR" != "" ]; then
            if [ -f $DATAFILE ]; then
                rm -f $TMP.1
                for s in $(cat $DATAFILE); do
		    echo "scale=9;" 1000 \* $s | bc >> $TMP.1
                done
		sort -n $TMP.1 > $TMP
                AVG=$(awk -f average.awk $TMP)
                P5=$(awk -f p5.awk $TMP)
                P95=$(awk -f p95.awk $TMP)
		if (( $(echo "$P5 < 0" | bc -l) )); then
		    P5_rel=$AVG
		else	
                    P5_rel=$(echo "scale=6;" "($AVG - $P5)" | bc)
		fi

		
                P95_rel=$(echo "scale=6;" "($P95 - $AVG)"  | bc)
		printf "\t%s\t%s\t%s" $AVG $P5_rel $P95_rel
            else
		printf "\t--\t--\t--"
            fi
	else
            if [ -f $DATAFILE ]; then
		AVG=$(awk -f average.awk $DATAFILE)
		# convert microseconds per byte to nanoseconds per byte
		printf "\t%s" $(echo "scale=9;" 1000 \* $AVG | bc)
            else
		printf "\t--"
            fi
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
