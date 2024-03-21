#
# Be sure to run `pod lib lint JLUsefulTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLUsefulTools'
  s.version          = '0.0.4'
  s.summary          = '一个用于数据处理的库'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '基本内容包括数据大小端转换/Data的裁剪/数据打包/基础UI等内容'

  s.homepage         = 'https://github.com/EzioChen/JLUsefulTools'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = 'MIT'
  s.author           = { 'EzioChan' => 'jackenwind@163.com' }
  s.source           = { :git => 'https://github.com/EzioChen/JLUsefulTools.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '12.0'

  s.source_files = 'JLUsefulTools/Classes/**/*'
  s.swift_versions = '5.0'
  
  s.dependency 'Alamofire', '>= 5.0.0'
  s.dependency 'SnapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  
  # s.resource_bundles = {
  #   'JLUsefulTools' => ['JLUsefulTools/Assets/*.png']
  # }
 
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
