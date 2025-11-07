Pod::Spec.new do |s|
  s.name             = 'boost_regex'
  s.version          = '1.0.0'
  s.summary          = 'Boost Regex library for iOS/macOS'
  s.description      = <<-DESC
    Boost Regex C++ library compiled for iOS, macOS, tvOS platforms
  DESC

  s.homepage         = 'https://github.com/your-repo/boost_regex'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Your Name' => 'your@email.com' }
  s.source           = { :git => 'https://github.com/your-repo/boost_regex.git', :tag => s.version.to_s }

  # Платформы
  s.ios.deployment_target = '12.0'
  s.osx.deployment_target = '10.13'
  s.tvos.deployment_target = '12.0'

  # Исходные файлы - прямо как в Bazel
  s.source_files = [
    'Sources/**/*.{c,cpp,h,hpp}'
  ]

  # Публичные заголовки
  s.public_header_files = 'include/**/*.{h,hpp}'

  # Пути заголовков
  s.header_mappings_dir = 'include'
  s.preserve_paths = 'include/**/*'

  # Compiler flags - путь относительно pod'а
  s.compiler_flags = [
    '-Iinclude'  # Теперь относительно корня pod'а
  ]

  # C++ настройки
  s.library = 'c++'
  s.pod_target_xcconfig = {
    'CLANG_CXX_LANGUAGE_STANDARD' => 'c++17',
    'CLANG_CXX_LIBRARY' => 'libc++',
    'HEADER_SEARCH_PATHS' => '$(PODS_TARGET_SRCROOT)/include'
  }

  # Если есть зависимости
  # s.dependency 'SomeOtherPod', '~> 1.0'
end