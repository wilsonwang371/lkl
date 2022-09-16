#!/bin/bash -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [ "${DOCKER}" == "1" ]
then
    #source /emsdk/emsdk_env.sh
    export PATH=/opt/wasi-sdk/bin:${PATH}
    make -C tools/lkl CC="clang -emit-llvm --target=wasm32 " SHELL="sh -x" -j ${CPU_AMOUNT}
else
    docker run -it --rm -e DOCKER=1 -e CPU_AMOUNT=$(nproc) -v ${SCRIPT_DIR}/../../:/root/lkl/:rw lkl-build:latest ./tools/lkl/build.sh
fi

