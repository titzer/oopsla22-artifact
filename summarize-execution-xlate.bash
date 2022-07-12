. ./common.bash

ENGINES=${ENGINES:="v8-turbofan sm-opt sm-base v8-liftoff wasm3 jsc-int wamr-fast wizard"}

if [ $# != 0 ]; then
    BENCHMARKS=$@
fi

# Execution time x translation time x translation space
echo Execution time x translation time x translation space
for engine in $ENGINES; do
    printf "\t%s" $engine
done
printf "\n"

for BENCHMARK in $BENCHMARKS; do
    printf "%s" $BENCHMARK
    
    for engine in $ENGINES; do
        DATAFILE=$DATA/execution.$BENCHMARK.$engine
        if [ -f $DATAFILE ]; then
            # execution time
            VAL=$(sed "-es/.*avg=\([0-9]*.[0-9]*\).*/\1/" $DATAFILE)
            printf "\t%s" $VAL
        else
            printf "\t--"
        fi
        
        # translation time
        DATAFILE=$DATA/translation.$BENCHMARK.$engine.us
        if [ -f $DATAFILE ]; then
            AVG=$(awk -f average.awk $DATAFILE)
            # convert microseconds per byte to nanoseconds per byte
            printf "\t%s" $(echo "scale=9;" 1000 \* $AVG | bc)
        else
            printf "\t--"
        fi

        # translation space
        DATAFILE=$DATA/translation.$BENCHMARK.$engine.bytes
        if [ -f $DATAFILE ]; then
            AVG=$(awk -f average.awk $DATAFILE)
            printf "\t%s" $AVG
        else
            printf "\t--"
        fi
    done
    printf "\n"
done
