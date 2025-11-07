#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
SOURCE_DIR="$SCRIPT_DIR/mozjpeg"
PUBLIC_DIR="$SCRIPT_DIR/Public/mozjpeg"

mkdir -p "$BUILD_DIR"/{arm64,sim_arm64,x86_64,frameworks}
mkdir -p "$PUBLIC_DIR"

download_cmake() {
    if [ ! -d "$SCRIPT_DIR/cmake" ]; then
        echo "Downloading CMake..."
        curl -L "https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-macos-universal.tar.gz" -o "$SCRIPT_DIR/cmake.tar.gz"
        mkdir -p "$SCRIPT_DIR/cmake"
        tar -xzf "$SCRIPT_DIR/cmake.tar.gz" -C "$SCRIPT_DIR/cmake"
        rm "$SCRIPT_DIR/cmake.tar.gz"
    fi
}

build_arch() {
    local ARCH=$1
    local ARCH_BUILD_DIR="$BUILD_DIR/$ARCH"

    echo "Building for architecture: $ARCH"

    rm -rf "$ARCH_BUILD_DIR"
    mkdir -p "$ARCH_BUILD_DIR"
    cd "$ARCH_BUILD_DIR"

    case $ARCH in
        "arm64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneOS.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneOS*.sdk)
            export CFLAGS="-Wall -arch arm64 -miphoneos-version-min=11.0 -funwind-tables"
            CMAKE_PROCESSOR="aarch64"
            ;;
        "sim_arm64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneSimulator.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneSimulator*.sdk)
            export CFLAGS="-Wall -arch arm64 --target=arm64-apple-ios11.0-simulator -miphonesimulator-version-min=11.0 -funwind-tables"
            CMAKE_PROCESSOR="aarch64"
            ;;
        "x86_64")
            IOS_PLATFORMDIR="$(xcode-select -p)/Platforms/iPhoneSimulator.platform"
            IOS_SYSROOT=($IOS_PLATFORMDIR/Developer/SDKs/iPhoneSimulator*.sdk)
            export CFLAGS="-Wall -arch x86_64 -miphoneos-version-min=11.0 -funwind-tables"
            CMAKE_PROCESSOR="AMD64"
            ;;
        *)
            echo "Unsupported architecture: $ARCH"
            exit 1
            ;;
    esac

    cat > toolchain.cmake << EOF
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR $CMAKE_PROCESSOR)
set(CMAKE_C_COMPILER $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
EOF

    "$CMAKE_PATH/cmake" -G"Unix Makefiles" \
        -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
        -DCMAKE_OSX_SYSROOT=${IOS_SYSROOT[0]} \
        -DPNG_SUPPORTED=FALSE \
        -DENABLE_SHARED=FALSE \
        -DWITH_JPEG8=1 \
        -DBUILD=10000 \
        "$SOURCE_DIR"

    make -j$(sysctl -n hw.ncpu)

    echo "Patching libjpeg.a with jpegtran symbols..."
    clang $CFLAGS -I. -I"$SOURCE_DIR" -c "$SOURCE_DIR/jpegtran.c" -o jpegtran.o
    clang $CFLAGS -I. -I"$SOURCE_DIR" -c "$SOURCE_DIR/transupp.c" -o transupp.o
    ar rcs libjpeg.a jpegtran.o transupp.o

    echo "Built $ARCH successfully"
}

create_xcframeworks() {
    echo "Creating XCFrameworks..."

    mkdir -p "$BUILD_DIR/frameworks"
    mkdir -p "$BUILD_DIR/universal"

    lipo -create \
        "$BUILD_DIR/sim_arm64/libjpeg.a" \
        "$BUILD_DIR/x86_64/libjpeg.a" \
        -output "$BUILD_DIR/universal/libjpeg.a"

    lipo -create \
        "$BUILD_DIR/sim_arm64/libturbojpeg.a" \
        "$BUILD_DIR/x86_64/libturbojpeg.a" \
        -output "$BUILD_DIR/universal/libturbojpeg.a"

    xcodebuild -create-xcframework \
        -library "$BUILD_DIR/arm64/libjpeg.a" \
        -headers "$PUBLIC_DIR" \
        -library "$BUILD_DIR/universal/libjpeg.a" \
        -headers "$PUBLIC_DIR" \
        -output "$BUILD_DIR/frameworks/libjpeg.xcframework"

    xcodebuild -create-xcframework \
        -library "$BUILD_DIR/arm64/libturbojpeg.a" \
        -headers "$PUBLIC_DIR" \
        -library "$BUILD_DIR/universal/libturbojpeg.a" \
        -headers "$PUBLIC_DIR" \
        -output "$BUILD_DIR/frameworks/libturbojpeg.xcframework"

    echo "XCFrameworks created successfully"
}

copy_headers() {
    echo "Copying headers..."
    cp "$SOURCE_DIR/turbojpeg.h" "$PUBLIC_DIR/"
    cp "$SOURCE_DIR/jpeglib.h" "$PUBLIC_DIR/"
    cp "$SOURCE_DIR/jmorecfg.h" "$PUBLIC_DIR/"
    cp "$BUILD_DIR/arm64/jconfig.h" "$PUBLIC_DIR/"
    echo "Headers copied successfully"
}

main() {
    echo "Starting MozJPEG build process..."

    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Error: MozJPEG source directory not found at $SOURCE_DIR"
        exit 1
    fi

    download_cmake
    export CMAKE_PATH="$SCRIPT_DIR/cmake/cmake-3.23.1-macos-universal/CMake.app/Contents/bin"
    export PATH="$PATH:$CMAKE_PATH"

    build_arch "arm64"
    build_arch "sim_arm64"
    build_arch "x86_64"

    create_xcframeworks
    copy_headers

    echo "MozJPEG build completed successfully!"
}

main "$@"
