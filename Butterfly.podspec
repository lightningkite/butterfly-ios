Pod::Spec.new do |s|
  s.name = "Butterfly"
  s.version = "0.2.0"
  s.summary = "Standard library for code translated from Kotlin to Swift"
  s.description = "The Butterfly Gradle plugin translates code from Kotlin to Swift, but in order to do so, a set of libraries must be present on both sides.  This is the iOS portion."
  s.homepage = "https://github.com/lightningkite/butterfly"

  s.license = "GPL"
  s.author = { "Captain" => "joseph@lightningkite.com" }
  s.platform = :ios, "10.0"
  s.source = { :git => "https://github.com/lightningkite/butterfly-ios.git", :tag => "#{s.version}", :submodules => true }
  s.source_files =  "Butterfly/**/*.{swift,swift.yml,swift.yaml}"

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
  s.dependency "RxSwift"
  s.dependency "RxRelay"
  s.dependency "Starscream"
  s.dependency "IBPCollectionViewCompositionalLayout"
  s.dependency "CollectionKit"

  s.subspec 'Core' do |core|
    core.source_files =  "Butterfly/src/**/*.{swift,swift.yml,swift.yaml}"
  end
  s.subspec 'Images' do |images|
    images.source_files =  "Butterfly/srcImages/**/*.{swift,swift.yml,swift.yaml}"
    images.dependency "DKImagePickerController/Core"
    images.dependency "DKImagePickerController/ImageDataManager"
    images.dependency "DKImagePickerController/Resource"
  end
  s.subspec 'Calendar' do |calendar|
    calendar.source_files =  "Butterfly/srcCalendar/**/*.{swift,swift.yml,swift.yaml}"
  end
  s.subspec 'Location' do |location|
    location.source_files =  "Butterfly/srcLocation/**/*.{swift,swift.yml,swift.yaml}"
  end
end
