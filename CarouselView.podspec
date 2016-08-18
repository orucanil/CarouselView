Pod::Spec.new do |s|

  s.name         = "CarouselView"
  s.version      = "1.0.2"
  s.summary      = "A carousel UIView subclass for iOS"
  s.license      = "MIT"
  s.homepage     = "https://github.com/orucanil/CarouselView"

  s.authors      = { "Anıl Oruç" => "", "Igor Silva" => "igor.silva@garrastudios.com" }
  s.platform     = :ios

  s.source       = { :git => "https://github.com/orucanil/CarouselView.git", :tag => "#{s.version}" }
  
  s.framework    = "QuartzCore"

  s.source_files = "CarouselView/*"

end
