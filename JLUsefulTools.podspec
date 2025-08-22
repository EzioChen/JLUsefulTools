#
# Be sure to run `pod lib lint JLUsefulTools.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'JLUsefulTools'
  s.version          = '0.0.5'
  s.summary          = '一个用于数据处理的库和 UI 相关的工具'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC 
**JLUsefulTools** 是一个用于数据处理的库和 UI 相关的工具，主要包括：
- 数据处理：大小端转换、Data 裁剪、数据打包；
- UI 工具：基于 SnapKit 与 RxSwift 的响应式 UI 组件；
- 文件相关：文件浏览、导入导出等辅助功能。
DESC

  s.homepage         = 'https://github.com/EzioChen/JLUsefulTools'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'EzioChan' => 'jackenwind@163.com' }
  s.source           = { :git => 'https://github.com/EzioChen/JLUsefulTools.git', :tag => s.version.to_s }

  s.platform         = :ios, '12.0'
  s.swift_versions   = ['5.0', '5.1', '5.2', '5.3', '5.4', '5.5']

  s.source_files     = 'JLUsefulTools/Classes/**/*'

  # 核心依赖
  s.dependency 'Alamofire', '>= 5.0.0'
  s.dependency 'SnapKit'
  s.dependency 'RxSwift'
  s.dependency 'RxCocoa'
  s.dependency 'FileBrowser'
  s.dependency 'GCDWebServer'
  
  # s.resource_bundles = {
  #   'JLUsefulTools' => ['JLUsefulTools/Assets/*.png']
  # }
 
  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
