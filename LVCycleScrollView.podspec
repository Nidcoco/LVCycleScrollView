#
#  Be sure to run `pod spec lint LVCycleScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "LVCycleScrollView"
  spec.version      = "1.0.4"
  spec.summary      = "banner控件."

  spec.description  = <<-DESC
                          banner控件,详细见README
                   DESC

  spec.homepage     = "https://github.com/li199508/LVCycleScrollView"

  spec.license          = { :type => 'MIT', :file => 'LICENSE' }

  spec.author             = { "Levi" => "2387356991@qq.com" }
  
  spec.source       = { :git => "https://github.com/li199508/LVCycleScrollView.git", :tag => "1.0.4" }


  spec.source_files  = "LVCycleScrollView/**/*.{h,m}"
  spec.requires_arc  = true
  spec.ios.deployment_target = '8.0'
  
  spec.dependency "SDWebImage", '>= 5.0.0'
  
  spec.user_target_xcconfig = {
    'GENERATE_INFOPLIST_FILE' => 'YES'
  }

  spec.pod_target_xcconfig = {
    'GENERATE_INFOPLIST_FILE' => 'YES'
  }



end
