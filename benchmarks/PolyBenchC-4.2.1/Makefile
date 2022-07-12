.PHONY: all

# TODO: figure out how to build both native and wasm without too much duplication

MEDIUM_MEMORY=8MB
LARGE_MEMORY=256MB

CC_NATIVE=clang++ -DMEDIUM_DATASET -lm -m64 -O3 -I utilities utilities/polybench.c
CC_WASM=emcc.py -DMEDIUM_DATASET -lm -O3 -s TOTAL_MEMORY=$(MEDIUM_MEMORY) -I utilities utilities/polybench.c

#CC=$(CC_NATIVE)
CC=$(CC_WASM)
#EXT=.native
EXT=.wasm

all: bin/floyd-warshall$(EXT) bin/nussinov$(EXT) bin/deriche$(EXT) bin/correlation$(EXT) bin/covariance$(EXT) bin/seidel-2d$(EXT) bin/adi$(EXT) bin/fdtd-2d$(EXT) bin/jacobi-1d$(EXT) bin/heat-3d$(EXT) bin/jacobi-2d$(EXT) bin/syr2k$(EXT) bin/gemver$(EXT) bin/gemm$(EXT) bin/symm$(EXT) bin/trmm$(EXT) bin/syrk$(EXT) bin/gesummv$(EXT) bin/doitgen$(EXT) bin/mvt$(EXT) bin/atax$(EXT) bin/3mm$(EXT) bin/2mm$(EXT) bin/bicg$(EXT) bin/ludcmp$(EXT) bin/cholesky$(EXT) bin/lu$(EXT) bin/trisolv$(EXT) bin/gramschmidt$(EXT) bin/durbin$(EXT)

LUCET_DIR=/project/titzer/lucet
LUCETC=$(LUCET_DIR)/target/release/lucetc

lucetbins: bin/floyd-warshall.lucet bin/nussinov.lucet bin/deriche.lucet bin/correlation.lucet bin/covariance.lucet bin/seidel-2d.lucet bin/adi.lucet bin/fdtd-2d.lucet bin/jacobi-1d.lucet bin/heat-3d.lucet bin/jacobi-2d.lucet bin/syr2k.lucet bin/gemver.lucet bin/gemm.lucet bin/symm.lucet bin/trmm.lucet bin/syrk.lucet bin/gesummv.lucet bin/doitgen.lucet bin/mvt.lucet bin/atax.lucet bin/3mm.lucet bin/2mm.lucet bin/bicg.lucet bin/ludcmp.lucet bin/cholesky.lucet bin/lu.lucet bin/trisolv.lucet bin/gramschmidt.lucet bin/durbin.lucet

# TODO: figure out how to factor out build rules for most binaries
bin/floyd-warshall$(EXT): medley/floyd-warshall/floyd-warshall.*
	$(CC) -o bin/floyd-warshall$(EXT) -I medley/floyd-warshall medley/floyd-warshall/floyd-warshall.c

bin/nussinov$(EXT): medley/nussinov/nussinov.*
	$(CC) -o bin/nussinov$(EXT) -I medley/nussinov medley/nussinov/nussinov.c

bin/deriche$(EXT): medley/deriche/deriche.*
	$(CC) -o bin/deriche$(EXT) -I medley/deriche medley/deriche/deriche.c

bin/correlation$(EXT): datamining/correlation/correlation.*
	$(CC) -o bin/correlation$(EXT) -I datamining/correlation datamining/correlation/correlation.c

bin/covariance$(EXT): datamining/covariance/covariance.*
	$(CC) -o bin/covariance$(EXT) -I datamining/covariance datamining/covariance/covariance.c

bin/seidel-2d$(EXT): stencils/seidel-2d/seidel-2d.*
	$(CC) -o bin/seidel-2d$(EXT) -I stencils/seidel-2d stencils/seidel-2d/seidel-2d.c

bin/adi$(EXT): stencils/adi/adi.*
	$(CC) -o bin/adi$(EXT) -I stencils/adi stencils/adi/adi.c

bin/fdtd-2d$(EXT): stencils/fdtd-2d/fdtd-2d.*
	$(CC) -o bin/fdtd-2d$(EXT) -I stencils/fdtd-2d stencils/fdtd-2d/fdtd-2d.c

bin/jacobi-1d$(EXT): stencils/jacobi-1d/jacobi-1d.*
	$(CC) -o bin/jacobi-1d$(EXT) -I stencils/jacobi-1d stencils/jacobi-1d/jacobi-1d.c

bin/heat-3d$(EXT): stencils/heat-3d/heat-3d.*
	$(CC) -o bin/heat-3d$(EXT) -I stencils/heat-3d stencils/heat-3d/heat-3d.c

bin/jacobi-2d$(EXT): stencils/jacobi-2d/jacobi-2d.*
	$(CC) -o bin/jacobi-2d$(EXT) -I stencils/jacobi-2d stencils/jacobi-2d/jacobi-2d.c

bin/syr2k$(EXT): linear-algebra/blas/syr2k/*
	$(CC) -o bin/syr2k$(EXT) -I linear-algebra/blas/syr2k/ linear-algebra/blas/syr2k/syr2k.c

bin/gemver$(EXT): linear-algebra/blas/gemver/*
	$(CC) -o bin/gemver$(EXT) -I linear-algebra/blas/gemver/ linear-algebra/blas/gemver/gemver.c

bin/gemm$(EXT): linear-algebra/blas/gemm/*
	$(CC) -o bin/gemm$(EXT) -I linear-algebra/blas/gemm/ linear-algebra/blas/gemm/gemm.c

bin/symm$(EXT): linear-algebra/blas/symm/*
	$(CC) -o bin/symm$(EXT) -I linear-algebra/blas/symm/ linear-algebra/blas/symm/symm.c

bin/trmm$(EXT): linear-algebra/blas/trmm/*
	$(CC) -o bin/trmm$(EXT) -I linear-algebra/blas/trmm/ linear-algebra/blas/trmm/trmm.c

bin/syrk$(EXT): linear-algebra/blas/syrk/*
	$(CC) -o bin/syrk$(EXT) -I linear-algebra/blas/syrk/ linear-algebra/blas/syrk/syrk.c

bin/gesummv$(EXT): linear-algebra/blas/gesummv/*
	$(CC) -o bin/gesummv$(EXT) -I linear-algebra/blas/gesummv/ linear-algebra/blas/gesummv/gesummv.c

bin/doitgen$(EXT): linear-algebra/kernels/doitgen/*
	$(CC) -o bin/doitgen$(EXT) -I linear-algebra/kernels/doitgen/ linear-algebra/kernels/doitgen/doitgen.c

bin/mvt$(EXT): linear-algebra/kernels/mvt/*
	$(CC) -o bin/mvt$(EXT) -I linear-algebra/kernels/mvt/ linear-algebra/kernels/mvt/mvt.c

bin/atax$(EXT): linear-algebra/kernels/atax/*
	$(CC) -o bin/atax$(EXT) -I linear-algebra/kernels/atax/ linear-algebra/kernels/atax/atax.c

bin/3mm$(EXT): linear-algebra/kernels/3mm/*
	$(CC) -o bin/3mm$(EXT) -I linear-algebra/kernels/3mm/ linear-algebra/kernels/3mm/3mm.c

bin/2mm$(EXT): linear-algebra/kernels/2mm/*
	$(CC) -o bin/2mm$(EXT) -I linear-algebra/kernels/2mm/ linear-algebra/kernels/2mm/2mm.c

bin/bicg$(EXT): linear-algebra/kernels/bicg/*
	$(CC) -o bin/bicg$(EXT) -I linear-algebra/kernels/bicg/ linear-algebra/kernels/bicg/bicg.c

bin/ludcmp$(EXT): linear-algebra/solvers/ludcmp/*
	$(CC) -o bin/ludcmp$(EXT) -I linear-algebra/solvers/ludcmp/ linear-algebra/solvers/ludcmp/ludcmp.c

bin/cholesky$(EXT): linear-algebra/solvers/cholesky/*
	$(CC) -o bin/cholesky$(EXT) -I linear-algebra/solvers/cholesky/ linear-algebra/solvers/cholesky/cholesky.c

bin/lu$(EXT): linear-algebra/solvers/lu/*
	$(CC) -o bin/lu$(EXT) -I linear-algebra/solvers/lu/ linear-algebra/solvers/lu/lu.c

bin/trisolv$(EXT): linear-algebra/solvers/trisolv/*
	$(CC) -o bin/trisolv$(EXT) -I linear-algebra/solvers/trisolv/ linear-algebra/solvers/trisolv/trisolv.c

bin/gramschmidt$(EXT): linear-algebra/solvers/gramschmidt/*
	$(CC) -o bin/gramschmidt$(EXT) -I linear-algebra/solvers/gramschmidt/ linear-algebra/solvers/gramschmidt/gramschmidt.c

bin/durbin$(EXT): linear-algebra/solvers/durbin/*
	$(CC) -o bin/durbin$(EXT) -I linear-algebra/solvers/durbin/ linear-algebra/solvers/durbin/durbin.c

%.lucet: %.wasm
	$(LUCETC) --bindings $(LUCET_DIR)/lucet-wasi/bindings.json -o $@ $<

clean:
	rm -f bin/*
