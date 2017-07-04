Pod::Spec.new do |s|

  s.name         = 'ChinoOSXLibrary'
  s.version      = '1.1'
  s.summary      = 'Chino iOS SDK'
  s.description  = 'Official Swift wrapper for CHINO.io API'

  s.homepage     = 'https://chino.io'
  s.license      = 'MIT'

  s.author             = { 'Paolo Prem' => 'prempaolo@gmail.com' }
  s.platform     = :ios, '8.0'

  s.source       = { :git => 'https://github.com/chinoio/chino-ios.git', :tag => s.version }

  s.source_files  = 'ChinoOSXLibrary/**/*.{swift,h,m}'
  s.preserve_path = 'CommonCrypto/module.modulemap'
  s.pod_target_xcconfig = {
    'SWIFT_INCLUDE_PATHS[sdk=iphonesimulator*]'  => '$(PODS_ROOT)/ChinoOSXLibrary/CommonCrypto'
  }
  s.ios.frameworks = 'UIKit', 'Foundation'

end
