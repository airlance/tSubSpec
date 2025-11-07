Pod::Spec.new do |s|
  s.name         = "ogg"
  s.version      = "1.0.0"
  s.summary      = "Ogg library"
  s.description  = <<-DESC
                   Wrapper around the Ogg C library.
                   DESC
  s.homepage     = "https://example.com/ogg"
  s.license      = { :type => "BSD", :file => "LICENSE" }
  s.author       = { "Your Name" => "you@example.com" }
  s.source       = { :git => "https://example.com/ogg.git", :tag => "#{s.version}" }

  s.source_files        = "Sources/*.{c,h}", "include/ogg/*.h"
  s.public_header_files = "include/ogg/*.h"
  s.header_mappings_dir = "include"

  s.requires_arc = false

  s.module_map = "module.modulemap"

  s.pod_target_xcconfig = {
    "HEADER_SEARCH_PATHS" => "$(PODS_TARGET_SRCROOT)/include"
  }
end
