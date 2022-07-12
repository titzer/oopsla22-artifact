#!/bin/bash

. ./common.bash

ENGINES=${ENGINES:=$XLATE_ENGINES}

if [ $# != 0 ]; then
    BENCHMARKS=$@
fi

PRINT_RATIO=0

function ratio() {
    if [ "$PRINT_RATIO" != "0" ]; then
        echo "$1"/"$2"
    else
        echo "scale=6;" "$1"/"$2" | bc
    fi
}

function extract_quantities() {
    a_count=$(echo $(grep $2.count $1 | cut -d: -f2))
    a_in=$(echo $(grep $2.in_bytes $1 | cut -d: -f2))
    a_out=$(echo $(grep $2.out_bytes $1 | cut -d: -f2))
    a_us=$(echo $(grep $2.us $1 | cut -d: -f2))
    
    us=$(ratio $a_us $a_in)
    bytes=$(ratio $a_out $a_in)
    echo us=$us bytes=$bytes count=$a_count
    echo $us >> $DATAFILE.us
    echo $bytes >> $DATAFILE.bytes
}

function extract_diff() {
    a_count=$(echo $(grep $3.count $1 | cut -d: -f2))
    a_in=$(echo $(grep $3.in_bytes $1 | cut -d: -f2))
    a_out=$(echo $(grep $3.out_bytes $1 | cut -d: -f2))
    a_us=$(echo $(grep $3.us $1 | cut -d: -f2))
    
    b_count=$(echo $(grep $3.count $2 | cut -d: -f2))
    b_in=$(echo $(grep $3.in_bytes $2 | cut -d: -f2))
    b_out=$(echo $(grep $3.out_bytes $2 | cut -d: -f2))
    b_us=$(echo $(grep $3.us $2 | cut -d: -f2))

    d_us=$(($a_us - $b_us))
    us=$(ratio $d_us $a_in)
    bytes=$(ratio $a_out $a_in)
    echo us=$us bytes=$bytes count=$a_count
    echo $us >> $DATAFILE.us
    echo $bytes >> $DATAFILE.bytes
}

function v8_liftoff_compile_time() {
    F=/tmp/v8-liftoff.translation
    $V8 $V8_TIER_LIFTOFF --dump-counters run.js -- $@ > $F
    extract_quantities $F liftoff
}

function v8_turbofan_compile_time() {
    F=/tmp/v8-turbofan.translation
    $V8 $V8_TIER_TURBOFAN --dump-counters run.js -- $@ > $F
    extract_quantities $F turbofan
}

function wasm3_translation_time() {
    F=/tmp/wasm3.compile
    $WASM3 $@ > $F
    extract_quantities $F m3
}

function wamr_fast_translation_time() {
    F=/tmp/iwasm-fast.validation
    $WAMR_FAST $@ > $F
    
    extract_quantities $F iwasm
}

function wamr_fast_translation_delta() {
    F=/tmp/iwasm-fast.validation
    $WAMR_FAST $@ > $F
    G=/tmp/iwasm-classic.validation
    $WAMR_CLASSIC $@ > $G
    
    extract_diff $F $G iwasm
}

function wizard_sidetable_time() {
    F=/tmp/wizard.validation
    $WIZENG_VALID $@ > $F
    G=/tmp/wizard-nosidetable.validation
    $WIZENG_NO_SIDETABLE $@ > $G
    
    extract_diff $F $G validated
}

function jsc_int_translation_time() {
    F=/tmp/jsc.int.translation
    $JSC $JSC_TIER_INT run.js -- $@ > $F
    extract_quantities $F llint
}

function jsc_bbq_compile_time() {
    F=/tmp/jsc.bbq.translation
    $JSC $JSC_TIER_BBQ run.js -- $@ > $F
    extract_quantities $F bbq
}

function jsc_omg_compile_time() {
    F=/tmp/jsc.omg.translation
    $JSC $JSC_TIER_OMG run.js -- $@  > $F
    extract_quantities $F bbq
}

function sm_base_compile_time() {
    F=/tmp/sm_base.translation
    $SM $SM_TIER_BASELINE run.js  $@ > $F
    extract_quantities $F base
}

function sm_opt_compile_time() {
    F=/tmp/sm_opt.translation
    $SM $SM_TIER_OPT run.js  $@ > $F
    extract_quantities $F opt
}

function run() {
    $COLORS && printf "$CYAN"
    engine=$1
    DATAFILE=$DATA/translation.$BENCHMARK.$engine
    rm -f $DATAFILE.*
    
    if [ "$RUNS" -gt 1 ]; then
        printf "%s" "$engine"
        shift
        $COLORS && printf "$NORM"
        printf "\n"
        i=0
        while [ $i -lt "$RUNS" ]; do
            VAL=$(echo $($@))
            printf "\t%-10s\n" "$VAL"
            i=$(($i + 1))
        done
    else
        printf "%-12s " "$engine"
        shift
        $COLORS && printf "$NORM"
        VAL=$($@)
        echo $VAL
        i=$(($i + 1))
    fi
}


for BENCHMARK in $BENCHMARKS; do
    p=./benchmarks/wasm/$BENCHMARK
    w=$p.wasm
    echo ---- $BENCHMARK -----------

    for ENGINE in $ENGINES; do
        case $ENGINE in
            "wizard")
                run "wizard" wizard_sidetable_time $w
                ;;
            "wasm3")
                run "wasm3" wasm3_translation_time $w
                ;;
            "wamr-fast")
                run "wamr-fast" wamr_fast_translation_delta $w
                ;;
            "jsc-int")
                run "jsc-int" jsc_int_translation_time $w
                ;;
            "v8-liftoff")
                run "v8-liftoff" v8_liftoff_compile_time $w
                ;;
            "jsc-bbq")
                run "jsc-bbq" jsc_bbq_compile_time $w
                ;;
            "sm-base")
                run "sm-base" sm_base_compile_time $w
                ;;
            "v8-turbofan")
                run "v8-turbofan" v8_turbofan_compile_time $w
                ;;
            "jsc-omg")
                run "jsc-omg" jsc_omg_compile_time $w
                ;;
            "sm-opt")
                run "sm-opt" sm_opt_compile_time $w
                ;;
            esac
            
    done
done
