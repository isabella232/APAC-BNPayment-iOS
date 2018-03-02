Pod::Spec.new do |spec|
  spec.name             = "APAC-BNPayment"
  spec.version          = "1.3.0"
  spec.summary          = "The Mobile Payment SDK from Bambora (APAC) makes it simple to accept credit card payments in your app."
  build_tag             = spec.version
  spec.homepage         = "http://bambora.com/en/au"
  spec.license          = 'MIT'
  spec.author           = { "APAC-BNPayment" => "apac-mobile-sdk-maintainers@bambora.com" }
  spec.source           = {
                          :git => "https://github.com/bambora/APAC-BNPayment-iOS.git",
                          :tag => build_tag.to_s
                          }
  spec.platform         = :ios, '8.0'
  spec.requires_arc     = true
  spec.module_name = 'BNPayment'
  spec.header_dir = 'BNPayment'
  spec.source_files     = 'BNPayment/**/**'
  spec.vendored_frameworks = 'Example/VisaCheckoutHybrid.framework'
  spec.dependency 'CardIO', '~> 5.4.1'
  spec.static_framework = true
  spec.resource_bundles = {
                            'BNPayment' => ['Assets/**/*.{png,bundle,xib,nib,cer,html}']
                          }
end