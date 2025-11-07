Pod::Spec.new do |spec|
  spec.name         = 'libprisma'
  spec.version      = '1.0.0'
  spec.summary      = 'Libprisma - Syntax highlighting library'
  spec.description  = <<-DESC
                      A syntax highlighting library with support for multiple programming languages.
                      Includes grammar definitions and tokenization capabilities.
                      DESC

  spec.homepage     = 'https://github.com/yourusername/libprisma'
  spec.license      = { :type => 'MIT', :file => 'LICENSE' }
  spec.author       = { 'Your Name' => 'your.email@example.com' }

  spec.ios.deployment_target = '12.0'
  spec.tvos.deployment_target = '12.0'
  spec.osx.deployment_target = '10.14'

  spec.source       = { :git => 'https://github.com/yourusername/libprisma.git', :tag => spec.version.to_s }

  spec.source_files = [
    'Sources/**/*.{c,cpp,m,mm,h,hpp}',
    'include/libprisma/*.h'
  ]

  spec.public_header_files = 'include/libprisma/*.h'
  spec.header_dir = 'libprisma'
  spec.xcconfig = {
    'HEADER_SEARCH_PATHS' => '$(PODS_ROOT)/libprisma/include'
  }
  spec.resources = 'Resources/**/*.dat'
  spec.resource_bundles = {
    'LibprismaBundle' => [
      'Resources/**/*.dat'
    ]
  }

  spec.frameworks = ['Foundation', 'UIKit']
  spec.dependency 'boost_regex'
  spec.module_name = 'libprisma'

  spec.pod_target_xcconfig = {
    'DEFINES_MODULE' => 'YES'
  }
end