#!/bin/bash -x

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )


if [ "${DOCKER}" == "1" ]
then
    source /emsdk/emsdk_env.sh
    make -C tools/lkl CC="clang" SHELL="bash -x" -j ${CPU_AMOUNT}
else
    docker run -it --rm -e DOCKER=1 -e CPU_AMOUNT=$(nproc) -v ${SCRIPT_DIR}/../../:/root/lkl/:rw lkl-build:latest ./tools/lkl/build.sh
fi

