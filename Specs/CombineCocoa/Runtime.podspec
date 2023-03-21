Pod::Spec.new do |s|
  s.name             = 'Runtime'
  s.version          = '0.4.0'
  s.summary          = 'CombineCocoa attempts to provide publishers for common UIKit controls'
  s.description  = <<-EOS
  CombineCocoa attempts to provide publishers for common UIKit controls.
  EOS

  s.homepage         = 'https://github.com/CombineCommunity/CombineCocoa'
  s.license          = 'MIT'
  s.author           = 'CombineCommunity'
  s.source           = { :git => 'https://github.com/CombineCommunity/CombineCocoa.git', :branch => "main"}

  s.swift_versions = ['5.5']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/Runtime/**/*.{h,m,swift}'
end
