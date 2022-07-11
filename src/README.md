# SOURCE DIRECTORY OVERVIEW

This artifact includes the full source checkouts of the various engines benchmarked in this paper,
each archived as a .zip before compilation.
Each engine is a git repository with branches that have engine-specific modifications to gather instrumentation.
It should not be necessary to rebuild the engines from source.
However, if rebuilding from source is required, the source folders can be removed and the archives re-extracted.
Note that some engines have multiple configurations that required modifications to configuration files and/or source.
Each is checked in as a separate git branch and indicated below; the results of the build process were copied
into the engines/ directory as shown.


# BASIC BUILD INSTRUCTIONS

## V8

```
% unzip v8.zip
% pushd v8
% gn gen x64.release --args="is_debug=false target_cpu=\"x64\" v8_target_cpu=\"x64\""
% ninja -C x64.release/d8
% popd
```

(resulting executable: `v8/x64.release/d8`)


## JSC

```
% unzip jsc.zip
% sudo apt install libicu-dev python ruby bison flex cmake build-essential ninja-build git gperf
% pushd WebKit
% Tools/Scripts/build-jsc --jsc-only --cmakeargs="-DENABLE_STATIC_JSC=ON -DUSE_THIN_ARCHIVES=OFF"
% popd
```

(resulting executable: `WebKit/WebKitBuild/Release/bin/jsc`)


## SPIDERMONKEY

```
% unzip spidermonkey.zip
% pushd gecko-dev
% cd js/src
% mkdir build_OPT.OBJ
% cd build_OPT.OBJ
% /bin/sh ../configure.in
% make
% popd
```

(resulting executable: `gecko-dev/js/src/build_OPT.OBJ/dist/bin/js`)


## WIZARD

```
% pushd virgil
% bin/dev/aeneas bootstrap x86-linux
% export PATH=$PATH:$(pwd)/bin/
% popd
% pushd wizard-engine
% make bin/wizeng.x86-64-linux
% popd
```

(resulting executable: `wizard-engine/bin/wizeng.x86-64-linux`)

There are 4 git branches in the source zip that build different versions of Wizard.

```
(branch exp_fast_config:                        cp wizard-engine/bin/wizeng.x86-64-linux ../engines/wizeng-fast)
(branch exp_slow_config:                        cp wizard-engine/bin/wizeng.x86-64-linux ../engines/wizeng-slow)
(branch exp_validate_only:                      cp wizard-engine/bin/wizeng.x86-64-linux ../engines/wizeng-valid)
(branch exp_validate_only_no_sidetable:         cp wizard-engine/bin/wizeng.x86-64-linux ../engines/wizeng-no-sidetable)
```


## WASM3
```
% pushd wasm3
% mkdir -p build
% cd build
% cmake ..
% make -j
% popd
```

(resulting executable: `source/wasm3/build/wasm3`)
(branch exp_instrumentation:            cp source/wasm3/build/wasm3 ../engines/)


## WAMR

```
% pushd wasm-micro-runtime
% cd product-mini/platforms/linux
% mkdir -p build
% cd build
% cmake ..
% make -j
% popd
```

(resulting executable: `wasm-micro-runtime/product-mini/platforms/linux/build/iwasm`)

There are 3 branches in the source zip that build different versions of WAMR.
```
(branch exp_classic:            cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-classic)
(branch exp_instrumentation:    cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-fast)
(branch exp_slow:               cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-slow)
```