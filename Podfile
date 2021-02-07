# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
source 'https://github.com/CocoaPods/Specs.git'
use_frameworks!


def commonPods
  pod 'SocketRocket'
  pod 'AFNetworking', '~> 4.0'
  pod 'MBProgressHUD'
  pod 'Masonry'
  # 图片多选
  pod 'TZImagePickerController'
  pod 'KSPhotoBrowser'
  pod 'BMKLocationKit'
  #百度地图SDK
  pod 'BaiduMapKit'
  pod 'IQKeyboardManager'
  pod 'SDWebImage', '>= 5.0.0'
  pod 'KafkaRefresh'
  pod 'YYModel'
  pod 'Bugly'
  pod 'GPUImage'
  pod 'YBImageBrowser'
end


target 'PersonInspection_CS' do
  commonPods
  
end

target 'PersonInspection' do
  # Comment the next line if you don't want to use dynamic frameworks
  commonPods
  target 'PersonInspectionTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'PersonInspectionUITests' do
    # Pods for testing
  end

end


