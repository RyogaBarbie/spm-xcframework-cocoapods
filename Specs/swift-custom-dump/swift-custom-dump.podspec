Pod::Spec.new do |s|
  s.name             = 'CustomDump'
  s.version          = '0.3.0'
  s.summary          = 'TBD'
  s.description  = <<-EOS
  TBD
  EOS

  s.homepage         = 'https://github.com/pointfreeco/swift-custom-dump'
  s.license          = 'MIT'
  s.author           = 'pointfreeco'
  s.source           = { :git => 'https://github.com/pointfreeco/swift-custom-dump.git', :tag => s.version.to_s }

  s.swift_versions = ['5.5']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/CustomDump/**/*.swift'
  s.dependency 'XCTestDynamicOverlay'
end
