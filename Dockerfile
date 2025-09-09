# syntax=docker/dockerfile:1

FROM ubuntu:22.04

ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y \
  build-essential \
  libssl-dev \
  libcurl4-openssl-dev \
  libexpat1-dev \
  gettext \
  unzip \
  tar \
  make \
  g++ \
  libtool \
  wget \
  python3 \
  git \
  ca-certificates \
  && rm -rf /var/lib/apt/lists/*

# Install ARM GCC Toolchain 10.3-2021.10
RUN mkdir -p /opt/toolchains/gcc-arm && \
    cd /opt/toolchains/gcc-arm && \
    wget https://developer.arm.com/-/media/Files/downloads/gnu-rm/10.3-2021.10/gcc-arm-none-eabi-10.3-2021.10-x86_64-linux.tar.bz2 -O toolchain.tar.bz2 && \
    tar -xjf toolchain.tar.bz2 && \
    rm toolchain.tar.bz2

ENV PATH="/opt/toolchains/gcc-arm/gcc-arm-none-eabi-10.3-2021.10/bin:$PATH"

# Install CMake 3.26.4
RUN mkdir -p /opt/cmake && \
    cd /opt/cmake && \
    wget https://github.com/Kitware/CMake/releases/download/v3.26.4/cmake-3.26.4.tar.gz && \
    tar -xvf cmake-3.26.4.tar.gz && \
    cd cmake-3.26.4 && \
    ./bootstrap && \
    make -j$(nproc) && \
    make install && \
    cmake --version

# Install Ruby and Ceedling dependencies
RUN apt-get update && apt-get install -y \
    ruby-full \
    gcc \
    gcovr \
    && rm -rf /var/lib/apt/lists/*
WORKDIR /opt/ceedling
RUN wget https://github.com/ThrowTheSwitch/Ceedling/releases/download/v1.0.1/ceedling-1.0.1.gem \
    && gem install ./ceedling-1.0.1.gem \
    && rm ceedling-1.0.1.gem

