Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  #
  #  These will help people to find your library, and whilst it
  #  can feel like a chore to fill in it's definitely to your advantage. The
  #  summary should be tweet-length, and the description more in depth.
  #

  s.name         = "HTSplashADView"
  s.version      = "0.0.3"
  s.summary      = "网易标准化控件库之 HTSplashADView."

  s.description  = <<-DESC
                   A longer description of HTSplashADView in Markdown format.
                   DESC

  s.homepage     = "https://github.com/NEYouFan/ht-refreshview-ios"


  s.license      = "MIT"

  s.author       = { "netease" => "taozeyu890217@126.com" }

  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/NEYouFan/ht-htsplashadview-ios", :tag => s.version.to_s }

  s.source_files  = "sources/*.{h,m}"

end