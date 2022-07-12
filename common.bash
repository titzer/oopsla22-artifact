#!/bin/bash

NORM='[0;00m'
GREEN='[0;32m'     ; LIGHTGREEN='[1;32m'
BROWN='[0;33m'     ; YELLOW='[1;33m'
PURPLE='[0;35m'    ; PINK='[1;35m'
BLACK='[0;30m'     ; DARKGRAY='[1;30m'
CYAN='[0;36m'      ; LIGHTCYAN='[1;36m'
BLUE='[0;34m'      ; LIGHTBLUE='[1;34m'
LIGHTGRAY='[0;37m' ; WHITE='[1;37m'
RED='[0;31m'       ; LIGHTRED='[1;31m'

SRC=./src
E=./engines

V8=$SRC/v8/x64.release/d8
JSC=$SRC/WebKit/WebKitBuild/Release/bin/jsc
SM=$SRC/gecko-dev/js/src/build_OPT.OBJ/dist/bin/js
WIZENG_VALID=$E/wizeng-valid
WIZENG_NO_SIDETABLE=$E/wizeng-no-sidetable
WIZENG_FAST=$E/wizeng-fast
WIZENG_SLOW=$E/wizeng-slow
WASM3=$E/wasm3
WAMR_SLOW=$E/iwasm-slow
WAMR_CLASSIC=$E/iwasm-classic
WAMR_FAST=$E/iwasm-fast

V8_TIER_LIFTOFF="--nowasm-tier-up"
V8_TIER_TURBOFAN="--noliftoff"
JSC_TIER_INT="--useOMGJIT=false --useBBQJIT=false"
JSC_TIER_OMG="--useWasmLLInt=false --useOMGJIT=false --useBBQJIT=true --wasmBBQUsesAir=false --webAssemblyBBQB3OptimizationLevel=2"
JSC_TIER_BBQ="--useWasmLLInt=false --useOMGJIT=false --useBBQJIT=true"
SM_TIER_BASELINE="--wasm-compiler=baseline"
SM_TIER_OPT="--wasm-compiler=optimizing"

COLORS=${COLORS:=true}
RUNS=${RUNS:=100}
DATA=${DATA:="./data"}

RAW_BENCHMARKS="nussinov correlation covariance seidel-2d adi fdtd-2d heat-3d jacobi-2d syr2k gemver gemm symm trmm syrk doitgen mvt atax 3mm 2mm bicg ludcmp cholesky lu gramschmidt"

LONG_BENCHMARKS="doitgen syrk correlation covariance symm syr2k gemm gramschmidt 2mm nussinov adi 3mm fdtd-2d jacobi-2d seidel-2d heat-3d cholesky ludcmp lu"

LONG_LARGE_BENCHMARKS="2mm 3mm adi cholesky correlation covariance deriche doitgen fdtd-2d floyd-warshall gemm gramschmidt heat-3d jacobi-2d ludcmp lu nussinov seidel-2d symm syr2k syrk trmm"

BENCHMARKS="bicg mvt atax gemver trmm doitgen syrk correlation covariance symm syr2k gemm gramschmidt 2mm nussinov adi 3mm fdtd-2d jacobi-2d seidel-2d heat-3d cholesky ludcmp lu"

EXE_ENGINES="sm-base sm-opt v8-liftoff v8-turbofan jsc-int jsc-bbq jsc-omg wizard wasm3 wamr-classic wamr-fast"
XLATE_ENGINES="wizard wasm3 wamr jsc-int v8-liftoff jsc-bbq v8-turbofan jsc-omg"

function get_engine_cmd() {
    engine=$1
    shift

    case $engine in
        "sm-base")
            echo $SM $SM_TIER_BASELINE run.js
            ;;
        "sm-opt")
            echo $SM $SM_TIER_OPT run.js
            ;;
        "v8-liftoff")
            echo $V8 $V8_TIER_LIFTOFF run.js --
            ;;
        "v8-turbofan")
            echo $V8 $V8_TIER_TURBOFAN run.js --
            ;;
        "jsc-int")
            echo $JSC $JSC_TIER_INT run.js --
            ;;
        "jsc-bbq")
            echo $JSC $JSC_TIER_BBQ run.js --
            ;;
        "jsc-omg")
            echo $JSC $JSC_TIER_OMG run.js --
            ;;
        "wizard")
            echo $WIZENG_FAST
            ;;
        "wizard-slow")
            echo $WIZENG_SLOW
            ;;
        "wasm3")
            echo $WASM3
            ;;
        "wamr-slow")
            echo $WAMR_SLOW
            ;;
        "wamr-classic")
            echo $WAMR_CLASSIC
            ;;
        "wamr-fast")
            echo $WAMR_FAST
            ;;
        *)
            echo ""
            ;;
    esac
    return 0;
}
