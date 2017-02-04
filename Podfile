source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!


target 'CodeChallenge' do
    pod 'ObjectMapper', '~> 2.0'
    pod 'SVProgressHUD' # Obj-c
    pod 'Alamofire', '~> 4.0'
    pod 'AlamofireImage', '~> 3.0'
    pod 'SwiftyJSON', '~> 3.0.0'
    pod 'SVPullToRefresh' # Obj-c
    pod 'DZNEmptyDataSet'
    
end

target 'CodeChallengeTests' do
    pod 'ObjectMapper', '~> 2.0'
    pod 'SwiftyJSON', '~> 3.0.0'
end


post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

#post_install do |installer|
#  installer.pods_project.targets.each do |target|
#    target.build_configurations.each do |config|
#      config.build_settings['SWIFT_VERSION'] = '3.0'
#			config.build_settings['MACOSX_DEPLOYMENT_TARGET'] = '10.10'
#    end
#  end
#end

