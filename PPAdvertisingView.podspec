Pod::Spec.new do |s|
  s.name         = "PPAdvertisingView"
  s.version      = "1.0.0"
  s.summary      = "PPAdvertisingView是一个集成UISCrollView与UIPageControll来完成市面上通用的广告页功能."

  s.description  = <<-DESC
                    PPAdvertisingView是一个集成UISCrollView与UIPageControll来完成市面上通用的广告页功能.
                    Github中已经能找到类似的开源代码，我为什么要再开发一个呢？主要出于以下几个原因:
                    * 代码比较混乱
                    * 耦合度太高
                   DESC

  s.homepage     = "https://github.com/smallmuou/PPAdvertisingView"
  s.license      = "MIT"
  s.author             = { "Pawpaw" => "lvyexuwenfa100@126.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/smallmuou/PPAdvertisingView.git", :tag => "1.0.0" }
  s.source_files = "PPAdvertisingView/Classes/*.{m,h}"
  s.requires_arc = true
  s.dependency "SDWebImage"

end
