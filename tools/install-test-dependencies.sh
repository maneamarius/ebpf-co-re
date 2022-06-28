#!/bin/env bash

set -e

KERNEL_VERSION=$(uname -r | cut -f 1 -d '-')
KERNEL_VERSION=${KERNEL_VERSION%.0}

apt update && apt -y install build-essential autoconf automake coreutils pkg-config bc libelf-dev libssl-dev clang-12 clang-tools-12 libclang-12-dev llvm-12 rsync bison flex tar xz-utils wget libbfd-dev libcap-dev || true

dnf update && sudo dnf -y install elfutils-libelf-devel autoconf automake pkg-config bc rsync && dnf -y groupinstall 'Development Tools' || true

ln -s /usr/bin/clang-12 /usr/bin/clang || true
ln -s /usr/bin/llvm-strip-12 /usr/bin/llvm-strip || true

mkdir -p /usr/src
cd /usr/src
wget -q https://cdn.kernel.org/pub/linux/kernel/v$(echo "$KERNEL_VERSION" | cut -f 1 -d '.').x/linux-${KERNEL_VERSION}.tar.xz
tar -xf linux-${KERNEL_VERSION}.tar.xz
make -C linux-${KERNEL_VERSION}/tools/bpf/bpftool/
cp linux-${KERNEL_VERSION}/tools/bpf/bpftool/bpftool /usr/bin/
