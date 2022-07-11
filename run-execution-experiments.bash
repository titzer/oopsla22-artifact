#!/bin/bash

. ./common.bash

if [ $# != 0 ]; then
    BENCHMARKS=$@
fi

function run() {
    $COLORS && printf "$CYAN"
    engine=$1
    DATAFILE=$DATA/execution.$BENCHMARK.$engine

    printf "%s" "$1"
    shift
    $COLORS && printf "$NORM"
    i=0
    TIMEFORMAT="%3R"
    if [ "$RUNS" = 1 ]; then
        ./btime $@ | tee $DATAFILE
    else
        ./btime $RUNS $@ | tee $DATAFILE
    fi
}

ENGINES=${ENGINES:=$EXE_ENGINES}

for BENCHMARK in $BENCHMARKS; do
    p=./benchmarks/wasm/$BENCHMARK
    w=$p.wasm
    echo ---- $BENCHMARK -----------

    for ENGINE in $ENGINES; do
        CMD=$(get_engine_cmd $ENGINE)
        run $ENGINE $CMD $w
    done
#    run "sm-base" $SM $SM_TIER_BASELINE run.js $w
#    run "sm-opt" $SM $SM_TIER_OPT run.js $w
#    run "v8-liftoff" $V8 $V8_TIER_LIFTOFF run.js -- $w
#    run "v8-turbofan" $V8 $V8_TIER_TURBOFAN run.js -- $w
#    run "jsc-int" $JSC $JSC_TIER_INT run.js -- $w
#    run "jsc-bbq" $JSC $JSC_TIER_BBQ run.js -- $w
#    run "jsc-omg" $JSC $JSC_TIER_OMG run.js -- $w
#    run wizard $WIZENG_FAST $w
#    run wasm3 $WASM3 $w
#    run wamr-slow $WAMR_SLOW $w
#    run wamr-classic $WAMR_CLASSIC $w
#    run wamr-fast $WAMR_FAST $w

#    run "jsc-def" $JSC run.js -- $w
#    run wizard-slow $WIZENG_SLOW $w
#    run wizeng-tagged $E/wizeng-unsafe-tagged $w
#    run wizeng-untagged $E/wizeng-unsafe-untagged $w
#    run wizeng-unthreaded $E/wizeng-unsafe-unthreaded $w
#    run "v8-def" $V8 run.js -- $w
#    run "sm-def" $SM run.js $w
    
done
cd

# TODO: https://github.com/Becavalier/TWVM
# TODO: https://github.com/paritytech/wasmi
# TODO: https://github.com/kanaka/wac
# TODO: https://github.com/inikep/lzbench
# TODO: https://github.com/bytecodealliance/sightglass

