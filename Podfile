source 'https://github.com/CocoaPods/Specs.git'
platform :ios, "9.0"
use_frameworks!
pod 'SnapKit', '~> 0.17.0'
pod "Koloda"
post_install do |installer|
`find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end