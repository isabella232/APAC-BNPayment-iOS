Pod::Spec.new do |spec|
  spec.name             = "APAC-BNPayment"
  spec.version          = "0.9.5"
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
  spec.source_files     = 'BNPayment/**/**'
  spec.vendored_frameworks = 'VisaCheckoutHybrid.framework'
  spec.resource_bundles = {
                            'BNPayment' => ['Assets/**/*.{png,bundle,xib,nib,cer,html}']
                          }
end
