Pod::Spec.new do |s|
  s.name             = 'ActomatonUI'
  s.version          = '0.7.0'
  s.summary          = 'Swift async/await & Actor-powered effectful state-management framework.'
  s.description  = <<-EOS
  Swift async/await & Actor-powered effectful state-management framework.
  EOS

  s.homepage         = 'https://github.com/inamiy/Actomaton'
  s.license          = 'MIT'
  s.author           = 'Yasuhiro Inami'
  s.source           = { :git => 'https://github.com/inamiy/Actomaton.git', :tag => s.version.to_s }

  s.swift_versions = ['5.5']
  s.ios.deployment_target = '14.0'

  s.source_files = 'Sources/ActomatonUI/**/*.swift'
  s.dependency 'Actomaton'
  s.dependency 'ActomatonDebugging'
end
