FROM ubuntu:focal

WORKDIR /

RUN apt-get update && \
    apt-get -yq install vim flex bison bc python3

RUN apt-get -yq install make git
RUN apt-get -yq install clang-12 llvm-12 lld-12

RUN apt-get -yq install wget

RUN ln -s $(which clang-12) /usr/bin/clang
RUN ln -s $(which llvm-ar-12) /usr/bin/llvm-ar
RUN ln -s $(which llvm-nm-12) /usr/bin/llnm-ar
RUN ln -s $(which ld.lld-12) /usr/bin/ld.lld

RUN ln -s $(which python3) /usr/bin/python

ENV WASI_VERSION=14
ENV WASI_VERSION_FULL=${WASI_VERSION}.0
RUN wget https://github.com/WebAssembly/wasi-sdk/releases/download/wasi-sdk-${WASI_VERSION}/wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
RUN tar xvf wasi-sdk-${WASI_VERSION_FULL}-linux.tar.gz
RUN mv wasi-sdk-${WASI_VERSION_FULL} /opt/wasi-sdk

#RUN git clone https://github.com/emscripten-core/emsdk.git
#WORKDIR /emsdk
#RUN git pull && \
#    ./emsdk install latest && \
#    ./emsdk activate latest && \
#    echo "\nsource /emsdk/emsdk_env.sh\n" >> /root/.bashrc

WORKDIR /root/lkl
