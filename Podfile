use_frameworks!
platform :ios, '8.0'
pod 'Kingfisher'
pod 'SnapKit'
post_install do |installer|
  installer.pods_project.targets.each do |target|
    target.build_configurations.each do |config|
      config.build_settings['ENABLE_BITCODE'] = 'NO'
    end
  end
end

