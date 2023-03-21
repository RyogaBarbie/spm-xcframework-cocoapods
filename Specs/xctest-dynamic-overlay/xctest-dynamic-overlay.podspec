Pod::Spec.new do |s|
  s.name             = 'XCTestDynamicOverlay'
  s.version          = '0.2.1'
  s.summary          = 'TBD'
  s.description  = <<-EOS
  TBD
  EOS

  s.homepage         = 'https://github.com/pointfreeco/xctest-dynamic-overlay'
  s.license          = 'MIT'
  s.author           = 'pointfreeco'
  s.source           = { :git => 'https://github.com/pointfreeco/xctest-dynamic-overlay.git', :tag => s.version.to_s }

  s.swift_versions = ['5.5']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/XCTestDynamicOverlay/**/*.swift'
end
