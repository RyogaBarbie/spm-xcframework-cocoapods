Pod::Spec.new do |s|
  s.name             = 'SherlockHUD'
  s.version          = '0.2.1'
  s.summary          = 'An elegant SwiftUI Form builder to create a searchable Settings and DebugMenu screens for iOS.'
  s.description  = <<-EOS
  An elegant SwiftUI Form builder to create a searchable Settings and DebugMenu screens for iOS.
  EOS

  s.homepage         = 'https://github.com/inamiy/SherlockForms'
  s.license          = 'MIT'
  s.author           = 'Yasuhiro Inami'
  s.source           = { :git => 'https://github.com/inamiy/SherlockForms.git', :tag => s.version.to_s }
  #s.source           = { :git => 'https://github.com/inamiy/SherlockForms.git', :branch => 'main' }

  s.swift_versions = ['5.6']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/SherlockHUD/**/*.swift'
end
