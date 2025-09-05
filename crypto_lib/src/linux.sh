#!/usr/bin/env bash
set -e

# Output directories
X86_DIR="x86_64"
ARM64_DIR="arm64"

mkdir -p "$X86_DIR" "$ARM64_DIR"

# Source files
SOURCES="fe.c ge.c keccak.c sc.c sha512.c on_chain_crypto.c"

# Compiler flags
CFLAGS="-O2 -fPIC -Wall -Werror"
LDFLAGS="-shared"

#########################
# Build x86_64
#########################
echo "Building x86_64..."
gcc $CFLAGS $SOURCES $LDFLAGS -o "$X86_DIR/libed25519.so"

#########################
# Build aarch64
#########################
echo "Building aarch64..."
aarch64-linux-gnu-gcc $CFLAGS $SOURCES $LDFLAGS -o "$ARM64_DIR/libed25519.so"

echo "Build complete!"
echo "x86_64 -> $X86_DIR/libed25519.so"
echo "arm64   -> $ARM64_DIR/libed25519.so"
