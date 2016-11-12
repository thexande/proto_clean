# Uncomment this line to define a global platform for your project
# platform :ios, '9.0'


target 'proto' do
  # Comment this line if you're not using Swift and don't want to use dynamic frameworks
  use_frameworks!

  # Pods for proto
    pod "Player", "~> 0.2.0"
    pod 'Firebase/Core'
    pod 'Firebase/Database'
    pod 'Firebase/Auth'
    # pod 'SwiftyTimer'
    # pod 'SlideMenuControllerSwift'
    # pod 'PermissionScope'

    post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
            end
        end
    end

  target 'protoTests' do
    inherit! :search_paths
    # Pods for testing
  end

  target 'protoUITests' do
    inherit! :search_paths
    # Pods for testing
  end

end
