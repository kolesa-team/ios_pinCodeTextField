Pod::Spec.new do |s|
    
    s.name             = 'KKPinCodeTextField'
    s.version          = '1.0.0'
    s.summary          = 'TextField for verification codes'
    
    s.description      = <<-DESC
    A customizable verification code textField. Can be used for phone verification codes, passwords etc.
    DESC
    
    s.homepage         = 'https://github.com/kolesa-team/ios_pinCodeTextField'
    s.license          = { :type => 'MIT', :file => 'LICENSE' }
    s.author           = { 'Author Name' => 'idryshev@kolesa.kz' }
    s.source           = { :git => 'https://github.com/kolesa-team/ios_pinCodeTextField.git', :tag => s.version.to_s }
    
    s.ios.deployment_target = '8.0'
    
    s.source_files = 'KKPinCodeTextField/Classes/**/*'
    
end
