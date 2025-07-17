#!/bin/bash
# manual-linux.sh: Builds Linux kernel, initramfs, and sets up QEMU

set -e

OUTDIR=$(realpath ${1:-/tmp/aesd-autograder})
mkdir -p "$OUTDIR"
echo "Using output directory: $OUTDIR"

KERNEL_REPO=https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git
KERNEL_VERSION=v5.15.163
ARCH=arm64
CROSS_COMPILE=aarch64-none-linux-gnu-

NUM_JOBS=$(nproc)

# Clone and build Linux kernel
cd "$OUTDIR"
if [ ! -d linux-stable ]; then
    echo "Cloning kernel..."
    git clone --depth 1 --branch ${KERNEL_VERSION} ${KERNEL_REPO} linux-stable
fi

cd linux-stable
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} mrproper
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} defconfig
make -j${NUM_JOBS} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} all
cp arch/${ARCH}/boot/Image "$OUTDIR/"

# Build BusyBox
cd "$OUTDIR"
if [ ! -d busybox ]; then
    git clone https://busybox.net/git/busybox.git
fi

cd busybox
make distclean
make defconfig
make -j${NUM_JOBS} ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE}
make ARCH=${ARCH} CROSS_COMPILE=${CROSS_COMPILE} CONFIG_PREFIX="${OUTDIR}/rootfs" install

# Create rootfs structure
cd "$OUTDIR"
rm -rf rootfs
mkdir -p rootfs/{bin,sbin,etc,proc,sys,dev,usr/bin,usr/sbin,lib,lib64,home/conf}

# Create device nodes
sudo mknod -m 666 rootfs/dev/null c 1 3
sudo mknod -m 600 rootfs/dev/console c 5 1

# Cross-compile writer
cd "${OUTDIR}/../../finder-app"
make clean
make CROSS_COMPILE=${CROSS_COMPILE}

# Copy app and scripts
cp writer "$OUTDIR/rootfs/home/"
cp finder.sh finder-test.sh autorun-qemu.sh "$OUTDIR/rootfs/home/"
cp conf/username.txt conf/assignment.txt "$OUTDIR/rootfs/home/conf/"

# Make sure autorun is executable
chmod +x "$OUTDIR/rootfs/home/autorun-qemu.sh"

# Set ownership to root
cd "$OUTDIR/rootfs"
sudo chown -R root:root .

# Create initramfs
find . | cpio -H newc -ov --owner root:root | gzip > "$OUTDIR/initramfs.cpio.gz"

