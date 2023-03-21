Pod::Spec.new do |s|
  s.name             = 'CasePaths'
  s.version          = '0.8.0'
  s.summary          = 'TBD'
  s.description  = <<-EOS
  TBD
  EOS

  s.homepage         = 'https://github.com/pointfreeco/swift-case-paths'
  s.license          = 'MIT'
  s.author           = 'pointfreeco'
  s.source           = { :git => 'https://github.com/pointfreeco/swift-case-paths.git', :tag => s.version.to_s }

  s.swift_versions = ['5.5']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/CasePaths/**/*.swift'
end
