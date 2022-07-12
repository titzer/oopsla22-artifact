# SOURCE DIRECTORY OVERVIEW

Source code for all engines used in the evaluation is, or should be, extracted to this directory.
Each engine is a git repository with branches that have engine-specific modifications to gather instrumentation.

## OOPSLA Artifact evaluation

This artifact includes the full source checkouts of the various engines benchmarked in this paper as `.zip` files.
The build results for all engines (i.e. runnable binaries) are included in this archive, pre-extracted.
Everything should run out of the box; you should be able to skip further steps in this file, unless something doesn't
work.
If you need to rebuild from source, the `.zip` files are here in the archive; no need to download from Google Drive.

## If you cloned from GitHub

For GitHub, the `.zip` files are too large to check in, so they are included as a drive link.

```
https://drive.google.com/drive/folders/1At4Wfpny4JVlmlbJkC1rkG5ufHv2sgg2?usp=sharing
```

In Google Drive there are `.src.zip` and `.bin.zip` files.
You should try first downloading and extracting the `.bin.zip` files and extracting them here, in the `src` directory.
These contain a snapshot of build artifacts that will hopefully work on your system.
If they do not, download the `.src.zip` files and follow the build instructions below.


# BASIC BUILD INSTRUCTIONS

Instructions for building from source, should that be necessary, are here.
Each is checked in as a separate git branch as indicated below; the results of the build process need to be copied
into the engines/ directory as shown.
The web engines (V8, SpiderMonkey, JavaScriptCore) run directly out of this directory, while the other engines
need to have their artifacts copied into the `engines` directory.
Note that some engines have multiple configurations that required different modifications to configuration files
and/or source, and each configuration is a separate git branch.

## V8

Commands:
```
unzip oopsla22-paper273-v8.src.zip
pushd v8
gn gen x64.release --args="is_debug=false target_cpu=\"x64\" v8_target_cpu=\"x64\""
ninja -C x64.release d8
popd
```

(resulting executable: `v8/x64.release/d8`)


## JAVASCRIPTCORE

Commands:
```
unzip oopsla22-paper273-jsc.src.zip
sudo apt install libicu-dev python ruby bison flex cmake build-essential ninja-build git gperf
pushd WebKit
Tools/Scripts/build-jsc --jsc-only --cmakeargs="-DENABLE_STATIC_JSC=ON -DUSE_THIN_ARCHIVES=OFF"
popd
```

(resulting executable: `WebKit/WebKitBuild/Release/bin/jsc`)


## SPIDERMONKEY

Commands:
```
unzip oopsla22-paper273-spidermonkey.src.zip
pushd gecko-dev
cd js/src
mkdir build_OPT.OBJ
cd build_OPT.OBJ
/bin/sh ../configure.in
make
popd
```

(resulting executable: `gecko-dev/js/src/build_OPT.OBJ/dist/bin/js`)


## WIZARD

Commands:
```
unzip oopsla22-paper273-virgil.src.zip
pushd virgil
bin/dev/aeneas bootstrap x86-linux
export PATH=$PATH:$(pwd)/bin/
popd
unzip oopsla22-paper273-wizard.src.zip
pushd wizard-engine
make bin/wizeng.x86-64-linux
popd
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
Commands:
```
unzip oopsla22-paper273-wasm3.src.zip
pushd wasm3
mkdir -p build
cd build
cmake ..
make -j
popd
```

(resulting executable: `source/wasm3/build/wasm3`)

```
(branch exp_instrumentation:            cp source/wasm3/build/wasm3 ../engines/)
```


## WAMR

Commands:
```
unzip oopsla22-paper273-wamr.src.zip
pushd wasm-micro-runtime
cd product-mini/platforms/linux
mkdir -p build
cd build
cmake ..
make -j
popd
```

(resulting executable: `wasm-micro-runtime/product-mini/platforms/linux/build/iwasm`)

There are 3 branches in the source zip that build different versions of WAMR.
```
(branch exp_classic:            cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-classic)
(branch exp_instrumentation:    cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-fast)
(branch exp_slow:               cp wasm-micro-runtime/product-mini/platforms/linux/build/iwasm ../engines/iwasm-slow)
```

# BACKUP PATCHES

As a backup in case it's not possible to either run binaries or unzip and build a source archive, patchfiles
are also provided.
They are located in the `patches/` directory and correspond to the `git diff` of the branches.
The git hash of each respective repo against which they are diffs are also provided.
