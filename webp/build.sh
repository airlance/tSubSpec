#!/bin/bash

set -e

# Определяем директории
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
SOURCE_DIR="$SCRIPT_DIR/libwebp"
PUBLIC_DIR="$SCRIPT_DIR/Public/libwebp"



# Создаем директории
mkdir -p "$BUILD_DIR"/{arm64,sim_arm64,x86_64,frameworks}
mkdir -p "$PUBLIC_DIR"

# Скачиваем CMake если его нет
download_cmake() {
    if [ ! -d "$SCRIPT_DIR/cmake" ]; then
        echo "Downloading CMake..."
        curl -L "https://github.com/Kitware/CMake/releases/download/v3.23.1/cmake-3.23.1-macos-universal.tar.gz" -o "$SCRIPT_DIR/cmake.tar.gz"
        mkdir -p "$SCRIPT_DIR/cmake"
        tar -xzf "$SCRIPT_DIR/cmake.tar.gz" -C "$SCRIPT_DIR/cmake"
        rm "$SCRIPT_DIR/cmake.tar.gz"
    fi
}
# Функция сборки для конкретной архитектуры
build_arch() {
    local ARCH=$1
    local ARCH_BUILD_DIR="$BUILD_DIR/$ARCH"

    echo "Building for architecture: $ARCH"

    rm -rf "$ARCH_BUILD_DIR"
    mkdir -p "$ARCH_BUILD_DIR"
    cd "$ARCH_BUILD_DIR"

    # Настройки для разных архитектур
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

    # Создаем toolchain.cmake
    cat > toolchain.cmake << EOF
set(CMAKE_SYSTEM_NAME Darwin)
set(CMAKE_SYSTEM_PROCESSOR $CMAKE_PROCESSOR)
set(CMAKE_C_COMPILER $(xcode-select -p)/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang)
EOF

    # Запускаем CMake
    "$CMAKE_PATH/cmake" -G"Unix Makefiles" \
        -DCMAKE_TOOLCHAIN_FILE=toolchain.cmake \
        -DCMAKE_OSX_SYSROOT=${IOS_SYSROOT[0]} \
        -DWEBP_LINK_STATIC=1 \
        -DWEBP_BUILD_CWEBP=0 \
        -DWEBP_BUILD_DWEBP=0 \
        -DWEBP_BUILD_IMG2WEBP=0 \
        -DWEBP_BUILD_ANIM_UTILS=0 \
        -DWEBP_BUILD_GIF2WEBP=0 \
        -DWEBP_BUILD_VWEBP=0 \
        -DWEBP_BUILD_WEBPINFO=0 \
        -DWEBP_BUILD_LIBWEBPMUX=0 \
        -DWEBP_BUILD_WEBPMUX=0 \
        -DWEBP_BUILD_EXTRAS=0 \
        "$SOURCE_DIR"

    # Собираем
    make -j$(sysctl -n hw.ncpu)

    echo "Built $ARCH successfully"
}

# Создаем XCFramework с правильной архитектурой
create_xcframeworks() {
    echo "Creating XCFrameworks..."

    # Создаем директории для фреймворков
    mkdir -p "$BUILD_DIR/frameworks"
    mkdir -p "$BUILD_DIR/universal"

    # Создаем универсальные библиотеки для симулятора (объединяем sim_arm64 и x86_64)
    echo "Creating universal simulator libraries..."

    lipo -create \
        "$BUILD_DIR/sim_arm64/libsharpyuv.a" \
        "$BUILD_DIR/x86_64/libsharpyuv.a" \
        -output "$BUILD_DIR/universal/libsharpyuv.a"

    lipo -create \
        "$BUILD_DIR/sim_arm64/libwebp.a" \
        "$BUILD_DIR/x86_64/libwebp.a" \
        -output "$BUILD_DIR/universal/libwebp.a"

  libtool -static -o "$BUILD_DIR/arm64/webp.a" \
      "$BUILD_DIR/arm64/libsharpyuv.a" \
      "$BUILD_DIR/arm64/libwebp.a"

  libtool -static -o "$BUILD_DIR/universal/webp.a" \
      "$BUILD_DIR/universal/libsharpyuv.a" \
      "$BUILD_DIR/universal/libwebp.a"

    # Создаем libjpeg XCFramework
    echo "Creating webp XCFramework..."
    xcodebuild -create-xcframework \
        -library "$BUILD_DIR/arm64/webp.a" \
        -headers "$PUBLIC_DIR" \
        -library "$BUILD_DIR/universal/webp.a" \
        -headers "$PUBLIC_DIR" \
        -output "$BUILD_DIR/frameworks/libwebp.xcframework"

    echo "XCFrameworks created successfully"

    echo ""
    find "$BUILD_DIR/frameworks" -name "*.xcframework" -exec echo "✅ Created: {}" \;
}

# Копируем заголовочные файлы
copy_headers() {
    echo "Copying headers..."

    cp "$SOURCE_DIR/src/webp/decode.h" "$PUBLIC_DIR/"
    cp "$SOURCE_DIR/src/webp/encode.h" "$PUBLIC_DIR/"
    cp "$SOURCE_DIR/src/webp/types.h" "$PUBLIC_DIR/"

    echo "Headers copied successfully"
}

# Основная функция
main() {
    echo "Starting Webp build process..."

    # Проверяем наличие исходного кода
    if [ ! -d "$SOURCE_DIR" ]; then
        echo "Error: Webp source directory not found at $SOURCE_DIR"
        exit 1
    fi

    # Скачиваем CMake
    download_cmake
    export CMAKE_PATH="$SCRIPT_DIR/cmake/cmake-3.23.1-macos-universal/CMake.app/Contents/bin"
    export PATH="$PATH:$CMAKE_PATH"

    # Собираем для всех архитектур
    build_arch "arm64"
    build_arch "sim_arm64"
    build_arch "x86_64"

    copy_headers
    create_xcframeworks

    echo "Webp build completed successfully!"
}

# Запускаем основную функцию
main "$@"