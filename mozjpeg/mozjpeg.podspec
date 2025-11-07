Pod::Spec.new do |spec|
spec.name = "mozjpeg"
  spec.version = "1.0.0"
  spec.summary = "MozJPEG library for iOS"
  spec.description = "MozJPEG library compiled for iOS with support for arm64 device and simulator architectures"
  spec.homepage = "https://github.com/mozilla/mozjpeg"
  spec.license = { :type => "MIT", :file => "LICENSE" }
  spec.author = { "Your Name" => "your.email@example.com" }

  spec.platform = :ios, '13.0'
  spec.source = { :git => "https://your-repo.git", :tag => "#{spec.version}" }

  # Используем XCFrameworks
  spec.vendored_frameworks = [
    'build/frameworks/libjpeg.xcframework',
    'build/frameworks/libturbojpeg.xcframework'
  ]

  spec.public_header_files = 'Public/mozjpeg/*.h'
  spec.source_files = 'Public/mozjpeg/*.h'

  spec.module_map = 'Public/mozjpeg/module.modulemap'

  spec.header_dir = 'mozjpeg'
  spec.module_name = 'mozjpeg'
  spec.requires_arc = false

  # Настройки сборки
  spec.xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/mozjpeg/Public/mozjpeg'
  }
end