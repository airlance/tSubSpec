#!/bin/bash

set -ex

# Configuration
HEADERS=("decode.h" "encode.h" "types.h")
LIBS=("webp" "sharpyuv")
SOURCE_PATH="libwebp"
OUTPUT_DIR="Public/webp"
CMAKE_VERSION="3.23.1"
CMAKE_URL="https://github.com/Kitware/CMake/releases/download/v${CMAKE_VERSION}/cmake-${CMAKE_VERSION}-macos-universal.tar.gz"

# Check if source directory exists
if [ ! -d "$SOURCE_PATH" ]; then
    echo "Error: Source directory $SOURCE_PATH not found"
    echo "Please ensure libwebp sources are available at $SOURCE_PATH"
    exit 1
fi

# Determine target architectures
ARCHS=("arm64" "sim_arm64" "x86_64")
if [ $# -gt 0 ]; then
    ARCHS=("$@")
fi

echo "Building for architectures: ${ARCHS[*]}"

# Setup build directory
BUILD_ROOT="$(pwd)/build"
rm -rf "$BUILD_ROOT"
mkdir -p "$BUILD_ROOT"

# Download and extract CMake if not available
CMAKE_DIR="$BUILD_ROOT/cmake"
if ! command -v cmake &> /dev/null; then
    echo "CMake not found in PATH, downloading..."
    mkdir -p "$CMAKE_DIR"
    curl -L "$CMAKE_URL" | tar -xz -C "$CMAKE_DIR"
    CMAKE_BIN="$CMAKE_DIR/cmake-${CMAKE_VERSION}-macos-universal/CMake.app/Contents/bin"
    export PATH="$PATH:$CMAKE_BIN"
fi

# Common CMake arguments
COMMON_ARGS="-DWEBP_LINK_STATIC=1 -DWEBP_BUILD_CWEBP=0 -DWEBP_BUILD_DWEBP=0 -DWEBP_BUILD_IMG2WEBP=0 -DWEBP_BUILD_ANIM_UTILS=0 -DWEBP_BUILD_GIF2WEBP=0 -DWEBP_BUILD_VWEBP=0 -DWEBP_BUILD_WEBPINFO=0 -DWEBP_BUILD_LIBWEBPMUX=0 -DWEBP_BUILD_WEBPMUX=0 -DWEBP_BUILD_EXTRAS=0"

# Function to build for specific architecture
build_arch() {
    local ARCH=$1
    echo "Building for architecture: $ARCH"

    local BUILD_DIR="$BUILD_ROOT/build_$ARCH"
    rm -rf "$BUILD_DIR"
    mkdir -p "$BUILD_DIR"

    # Copy source
    cp -R "$SOURCE_PATH" "$BUILD_DIR/"

    # Configure build settings based on architecture
    case "$ARCH" in
        "arm64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneOS.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS*.sdk)
            export CFLAGS="-Wall -arch arm64 -miphoneos-version-min=13.0 -funwind-tables"
            CMAKE_PROCESSOR="aarch64"
            ;;
        "sim_arm64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneSimulator.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneSimulator*.sdk)
            export CFLAGS="-Wall -arch arm64 --target=arm64-apple-ios13.0-simulator -miphonesimulator-version-min=13.0 -funwind-tables"
            CMAKE_PROCESSOR="aarch64"
            ;;
        "x86_64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneSimulator.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneSimulator*.sdk)
            export CFLAGS="-Wall -arch x86_64 -miphoneos-version-min=13.0 -funwind-tables"
            CMAKE_PROCESSOR="AMD64"
            ;;
        *)
            echo "Unsupported architecture $ARCH"
            return 1
            ;;
    esac

    # Build
    cd "$BUILD_DIR"
    mkdir build
    cd build

    # Create toolchain file
    cat > toolchain.cmake << EOF
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR ${CMAKE_PROCESSOR})
set(CMAKE_C_COMPILER $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
EOF

    # Configure and build
    cmake -G"Unix Makefiles" -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake -DCMAKE_OSX_SYSROOT=${IOS_SYSROOT[0]} $COMMON_ARGS ../libwebp
    make -j$(sysctl -n hw.ncpu)

    echo "Build completed for $ARCH"
}

# Build all architectures
LIB_PATHS=()
for ARCH in "${ARCHS[@]}"; do
    build_arch "$ARCH"

    # Store library paths for later use
    for LIB in "${LIBS[@]}"; do
        LIB_PATHS+=("$BUILD_ROOT/build_$ARCH/build/lib$LIB.a")
    done
done

# Create output directories
mkdir -p "$OUTPUT_DIR/lib"

# Copy headers from the first build (they should be identical)
FIRST_BUILD="$BUILD_ROOT/build_${ARCHS[0]}"
for HEADER in "${HEADERS[@]}"; do
    if [ -f "$FIRST_BUILD/libwebp/src/webp/$HEADER" ]; then
        cp -f "$FIRST_BUILD/libwebp/src/webp/$HEADER" "$OUTPUT_DIR/$HEADER"
        echo "Copied header: $HEADER"
    else
        echo "Warning: Header $HEADER not found"
    fi
done

# Handle libraries - create universal binaries if multiple architectures
if [ ${#ARCHS[@]} -gt 1 ]; then
    echo "Creating universal libraries..."
    for LIB in "${LIBS[@]}"; do
        LIB_INPUTS=()
        for ARCH in "${ARCHS[@]}"; do
            LIB_FILE="$BUILD_ROOT/build_$ARCH/build/lib$LIB.a"
            if [ -f "$LIB_FILE" ]; then
                LIB_INPUTS+=("$LIB_FILE")
            fi
        done

        if [ ${#LIB_INPUTS[@]} -gt 0 ]; then
            lipo -create "${LIB_INPUTS[@]}" -output "$OUTPUT_DIR/lib/lib$LIB.a"
            echo "Created universal library: lib$LIB.a"
        else
            echo "Warning: No libraries found for $LIB"
        fi
    done
else
    # Single architecture - just copy
    ARCH="${ARCHS[0]}"
    for LIB in "${LIBS[@]}"; do
        LIB_FILE="$BUILD_ROOT/build_$ARCH/build/lib$LIB.a"
        if [ -f "$LIB_FILE" ]; then
            cp -f "$LIB_FILE" "$OUTPUT_DIR/lib/lib$LIB.a"
            echo "Copied library: lib$LIB.a"
        else
            echo "Warning: Library $LIB not found"
        fi
    done
fi

# Verify output
echo ""
echo "Build completed successfully!"
echo "Output directory: $OUTPUT_DIR"
echo "Headers:"
for HEADER in "${HEADERS[@]}"; do
    if [ -f "$OUTPUT_DIR/$HEADER" ]; then
        echo "  ✓ $HEADER"
    else
        echo "  ✗ $HEADER (missing)"
    fi
done
echo "Libraries:"
for LIB in "${LIBS[@]}"; do
    if [ -f "$OUTPUT_DIR/lib/lib$LIB.a" ]; then
        echo "  ✓ lib$LIB.a"
        # Show architecture info
        lipo -info "$OUTPUT_DIR/lib/lib$LIB.a" | sed 's/^/    /'
    else
        echo "  ✗ lib$LIB.a (missing)"
    fi
done

# Cleanup
if [ "$CLEANUP" = "1" ]; then
    echo "Cleaning up build directory..."
    rm -rf "$BUILD_ROOT"
fi

echo "Done!"