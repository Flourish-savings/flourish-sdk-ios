Pod::Spec.new do |s|
  s.name         = 'FlourishSDK'
  s.version      = '1.0.0'
  s.summary      = 'Flourish SDK'
  s.description  = <<-DESC
    A library to integrate with Flourish.
    DESC
  s.homepage     = 'https://github.com/Flourish-savings/flourish-sdk-ios'
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'Pedro Modrach' => 'pedro.modrach@flourishfi.com' }
  s.source       = { :git => 'https://github.com/Flourish-savings/flourish-sdk-ios.git', :tag => s.version.to_s }
  s.platform     = :ios, '12.0'
  s.source_files = 'Sources/FlourishSDK/**/*.{swift}'
  s.dependency 'Alamofire', '~> 5.9'
  s.frameworks   = 'UIKit'
  s.swift_version = '5.0'
end
