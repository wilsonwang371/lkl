#!/usr/bin/env bash

PWD=`pwd`
LKL="$PWD/tools/lkl"

CC="emcc"
CP="cp"
DIS="llvm-dis"
LINK="llvm-link"
PY="python"

CFLAGS="-m32"
CFLAGS="$CFLAGS -s WASM=0"
CFLAGS="$CFLAGS -s ASYNCIFY=1"
CFLAGS="$CFLAGS -s EMULATE_FUNCTION_POINTER_CASTS=1"
CFLAGS="$CFLAGS -s USE_PTHREADS=1"
CFLAGS="$CFLAGS -s PTHREAD_POOL_SIZE=16"
CFLAGS="$CFLAGS -s TOTAL_MEMORY=1342177280"
CFLAGS="$CFLAGS -s ERROR_ON_UNDEFINED_SYMBOLS=0"
CFLAGS="$CFLAGS -fno-short-wchar"
CFLAGS="$CFLAGS -O0"
CFLAGS="$CFLAGS -g4"

echo "LINK liblkl.bc"
$LINK -o $LKL/lib/liblkl.bc \
    $LKL/lib/liblkl-in.o $LKL/lib/lkl.o
echo "DIS liblkl.bc"
$DIS -o $LKL/lib/liblkl.ll $LKL/lib/liblkl.bc
mkdir -p js
touch /tmp/dummy.c
EMCC_DEBUG=1 $CC -o /tmp/dummy.js /tmp/dummy.c $CFLAGS
for bc in `ls ~/.emscripten_cache/asmjs | grep "\.bc"`; do
  $CP ~/.emscripten_cache/asmjs/$bc js/$bc
done
for bc in `ls js | grep "\.bc"`; do
  echo "DIS $bc"
  $DIS -o js/`echo $bc | sed 's/\.[^\.]*$/.ll/'` js/$bc
done
echo "PY rename_symbols.py"
$PY rename_symbols.py $LKL/lib/liblkl.ll $LKL/lib/liblkl-mod.ll

EX_FUNCS="$(grep "@lkl_" $LKL/lib/liblkl-mod.ll \
    | grep "define" | grep -v "internal" \
    | $PY ex_funcs.py)"
CFLAGS="$CFLAGS -s EXPORTED_FUNCTIONS=$EX_FUNCS"

echo "EMCC liblkl.js"
EMCC_DEBUG=1 $CC -o js/liblkl.js $LKL/lib/liblkl-mod.ll $CFLAGS -v
echo "PY fix-js.py"
$PY fix-js.py js/liblkl.js js/liblkl.js
