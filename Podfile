# Uncomment the next line to define a global platform for your project
# platform :ios, '11.0'

target 'ITEvents' do

  use_frameworks!
  pod 'SwinjectStoryboard'
  pod 'Reusable'
  pod 'TagListView'
  pod 'PromisesSwift'
  
  post_install do |installer|
      myTargets = ['SwinjectStoryboard', 'Reusable', 'TagListView']
      installer.pods_project.targets.each do |target|
          if myTargets.include? target.name
              target.build_configurations.each do |config|
                  config.build_settings['SWIFT_VERSION'] = '4.0'
              end
          end
      end
  end
end

target 'ITEventsTests' do
    use_frameworks!
    pod 'PromisesSwift'
end
