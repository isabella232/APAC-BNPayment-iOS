Pod::Spec.new do |spec|
  spec.name             = "APAC-BNPayment"
  spec.version          = ENV['LIBRARY_VERSION'] ? ENV['LIBRARY_VERSION'] : "1.2.3"
  spec.summary          = "The Mobile Payment SDK from Bambora (APAC) makes it simple to accept credit card payments in your app."
  build_tag             = spec.version
  spec.homepage         = "http://bambora.com/en/au"
  spec.license          = 'MIT'
  spec.author           = { "Bambora APAC" => "setup.apac@bambora.com" }
  spec.source           = {
                          :git => "https://github.com/bambora/APAC-BNPayment-iOS.git",
                          :tag => build_tag.to_s
                          }
  spec.platform         = :ios, '8.0'
  spec.requires_arc     = true
  spec.source_files     = 'BNPayment/**/*.{h,m}'
  spec.resource_bundles = {
                            'BNPayment' => ['Assets/**/*.{png,bundle,xib,nib,cer}']
                          }
end
