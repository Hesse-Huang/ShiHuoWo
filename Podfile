source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '8.0'
use_frameworks!

pod 'Alamofire', '~> 3.2.1'
pod 'SwiftyJSON', '~> 2.3.2'
pod 'Kingfisher', '~> 2.1.0'
pod 'UIColor_Hex_Swift', '~> 2.0'
pod 'DZNEmptyDataSet', '~> 1.7.3'
pod 'JDAnimationKit', '~> 1.0.1'

post_install do |installer|
  `find Pods -regex 'Pods/pop.*\\.h' -print0 | xargs -0 sed -i '' 's/\\(<\\)pop\\/\\(.*\\)\\(>\\)/\\"\\2\\"/'`
end