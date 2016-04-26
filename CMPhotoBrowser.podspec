
Pod::Spec.new do |s|
  
  s.name = "CMPhotoBrowser"
  s.version      = "0.0.1"
  s.summary      = "轻量级图片浏览器"
  s.homepage     = "https://github.com/MyGitHub75/CMPhotoBrowser"
  s.license      = "MIT"
  s.author       = { "chen chuan mao" => "chenye.75@163.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/MyGitHub75/CMPhotoBrowser.git", :tag => s.version }
  s.source_files = "CMPhotoBrowser/CMPhotoBrowser/*.{h,m}"
  s.resources    = "CMPhotoBrowser/CMPhotoBrowser/CMLoadingPic.bundle"
  s.requires_arc = true
  s.dependency "SDWebImage"

end
