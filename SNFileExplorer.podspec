Pod::Spec.new do |s|
  s.requires_arc = true
  s.name         = 'SNFileExplorer'
  s.version      = '0.0.1'
  s.summary      = "20180819"
  s.homepage     = "https://github.com/sixTiger/XXBExplorer"
  s.license      = "MIT"
  s.authors      = { '杨小兵' => 'xiaobing5@staff.sina.com.cn' }
  s.platform     = :ios
  s.ios.deployment_target = '7.0'
  s.source       = { :git => "https://github.com/sixTiger/XXBExplorer.git", :tag => s.version }
  s.public_header_files = 'SNFileExplorer/SNFileExplorer.h'
  s.source_files = 'SNFileExplorer/SNFileExplorer.h'
  s.requires_arc  = true

  s.subspec 'UI' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.source_files = 'SNFileExplorer/UI/*.{h,m}'
    ss.public_header_files = 'SNFileExplorer/UI/SNFileExplorerController.h'
  end

  s.subspec 'Util' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.source_files = 'SNFileExplorer/Util/*.{h,m}'
    ss.public_header_files = 'SNFileExplorer/Util/*.h'
  end
end
