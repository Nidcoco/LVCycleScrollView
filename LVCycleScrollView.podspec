#
#  Be sure to run `pod spec lint LVCycleScrollView.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|

  spec.name         = "LVCycleScrollView"
  spec.version      = "0.0.1"
  spec.summary      = "图片及文字自动滚动的控件."

  spec.description  = <<-DESC
                        图片及文字自动滚动的控件,详细见README
                   DESC

  spec.homepage     = "https://github.com/li199508/LVCycleScrollView"

  spec.license          = { :type => 'MIT', :file => 'LICENSE' }

  spec.author             = { "lijunyu" => "lijy@figo.cn" }
  
  spec.source       = { :git => "https://github.com/li199508/LVCycleScrollView.git", :tag => "0.0.1" }


  spec.source_files  = "LVCycleScrollView/**/*.{h,m}"
  spec.requires_arc  = true
  spec.ios.deployment_target = '8.0'
  
  #TAPageControl
  spec.subspec 'TAPageControl' do |ta|
      ta.source_files = 'LVCycleScrollView/TAPageControl/*.{h,m}'
      ta.frameworks = 'Foundation','UIKit'
  end



end
