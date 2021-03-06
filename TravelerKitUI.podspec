Pod::Spec.new do |spec|
  spec.name         = 'TravelerKitUI'
  spec.version      = '0.1.0'
  spec.license      = { :type => 'Apache' }
  spec.homepage     = 'https://github.com/Guestlogix/traveler-ios'
  spec.authors      = { 'Ata N' => 'anamvari@guestlogix.com' }
  spec.summary      = 'Traveler Platform iOS UI SDK'
#  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :tag => '0.1.0' }
  spec.source       = { :git => 'https://github.com/Guestlogix/traveler-ios.git', :branch => 'master' }
  spec.swift_version = "5.0"

  spec.ios.dependency 'TravelerKit'

  spec.platform = :ios
  spec.ios.deployment_target = "11.4"

  spec.framework = "UIKit"
  spec.source_files = "traveler-ios-ui/TravelerKitUI/**/*.{swift}"
  spec.resources = "traveler-ios-ui/TravelerKitUI/**/*.{xib,storyboard}"
  spec.resource_bundle = { 'TravelerKitUI' => 'traveler-ios-ui/TravelerKitUI/**/*.{xib,
  storyboard}' }
  spec.module_name = "TravelerKitUI"
end
