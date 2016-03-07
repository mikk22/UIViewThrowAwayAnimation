Pod::Spec.new do |spec|
  spec.name         = "UIViewThrowAwayAnimation"
  spec.version      = "0.1"
  spec.summary      = "UIViewThrowAwayAnimation"
  spec.homepage     = "https://github.com/mikk22/UIViewThrowAwayAnimation"
  spec.license      = 'none'
  spec.author       = { "Mihail Koltsov" => "mikk.22@gmail.com" }
  spec.platform     = :ios, '6.0'
  spec.source       = { :git => "https://github.com/mikk22/UIViewThrowAwayAnimation.git", :tag => spec.version.to_s }
  spec.source_files  = 'UIViewThrowAwayAnimation/*.{h,m}'
  spec.public_header_files = 'UIViewThrowAwayAnimation/*.h'
  spec.frameworks    = 'Foundation'
  spec.requires_arc = true
end
