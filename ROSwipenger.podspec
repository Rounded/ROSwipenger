#
# Be sure to run `pod lib lint ROSwipenger.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "ROSwipenger"
  s.version          = "0.0.8"
  s.summary          = "Lazy loading sliding page view controller!"
  s.description      = <<-DESC
                       This is a sliding page view controller that lazily loads in the child view controllers.
                       DESC
  s.homepage         = "https://github.com/Rounded/ROSwipenger"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Heather Snepenger" => "hs@roundedco.com" }
  s.source           = { :git => "https://github.com/Rounded/ROSwipenger.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/roundedco'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes'
  s.resource_bundles = {
    'ROSwipenger' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.dependency 'PureLayout'
end
