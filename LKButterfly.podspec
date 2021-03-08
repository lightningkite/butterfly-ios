Pod::Spec.new do |s|
  s.name = "LKButterfly"
  s.version = "0.1.0"
  s.summary = "Standard library for code translated from Kotlin to Swift"
  s.description = "The Butterfly Gradle plugin translates code from Kotlin to Swift, but in order to do so, a set of libraries must be present on both sides.  This is the iOS portion."
  s.homepage = "https://github.com/lightningkite/butterfly-ios"

  s.license = "MIT"
  s.author = { "Captain" => "joseph@lightningkite.com" }
  s.platform = :ios, "11.0"
  s.source = { :git => "https://github.com/lightningkite/butterfly-ios.git", :tag => "#{s.version}", :submodules => true }
  s.source_files =  "LKButterfly/**/*.{swift,swift.yml,swift.yaml}"

  s.pod_target_xcconfig = { "DEFINES_MODULE" => "YES" }

  s.requires_arc = true
  s.swift_version = '5.3'
  s.xcconfig = { 'SWIFT_VERSION' => '5.3' }
  s.dependency "Alamofire"
  s.dependency "AlamofireImage"
  s.dependency "KeychainAccess"
  s.dependency "UITextView+Placeholder"
  s.dependency "Cosmos"
  s.dependency "SearchTextField"
  s.dependency "RxSwift", "5.1.1" 
  s.dependency "RxRelay", "5.1.1"
  s.dependency "Starscream"
  s.dependency "IBPCollectionViewCompositionalLayout"

  s.subspec 'Core' do |core|
    core.source_files =  "LKButterfly/src/**/*.{swift,swift.yml,swift.yaml}"
  end
  s.subspec 'Images' do |images|
    images.source_files =  "LKButterfly/srcImages/**/*.{swift,swift.yml,swift.yaml}"
    images.dependency "LKButterfly/Core"
    images.dependency "DKImagePickerController/Core"
    images.dependency "DKImagePickerController/ImageDataManager"
    images.dependency "DKImagePickerController/Resource"
    images.dependency "DKImagePickerController/Camera"
  end
  s.subspec 'Calendar' do |calendar|
    calendar.dependency "LKButterfly/Core"
    calendar.source_files =  "LKButterfly/srcCalendar/**/*.{swift,swift.yml,swift.yaml}"
  end
  s.subspec 'Location' do |location|
    location.dependency "LKButterfly/Core"
    location.source_files =  "LKButterfly/srcLocation/**/*.{swift,swift.yml,swift.yaml}"
  end
end
