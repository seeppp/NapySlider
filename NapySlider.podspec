Pod::Spec.new do |s|
  s.name             = "NapySlider"
  s.version          = "0.2"
  s.summary          = "A vertical slider UIControl element written in swift."
  s.homepage         = "https://github.com/seeppp/NapySlider"
  # s.screenshots     = "https://github.com/seeppp/NapySlider/blob/master/exampleImages/napyslidermov.gif"
  s.license          = 'MIT'
  s.author           = { "Jonas Schoch" => "jonas.schoch@naptics.ch" }
  s.source           = { :git => "https://github.com/seeppp/NapySlider.git", :tag => s.version.to_s }
  s.platform     = :ios, '8.3'
  s.requires_arc = true
  s.source_files = 'NapySlider/NapySlider.swift'
end
