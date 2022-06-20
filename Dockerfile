From aflplusplus/aflplusplus:latest

ARG TARGET_ARCH

RUN CPU_TARGET=$TARGET_ARCH make distrib && make install && make clean