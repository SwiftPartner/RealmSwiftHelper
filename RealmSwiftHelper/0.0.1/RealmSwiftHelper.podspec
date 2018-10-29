# 执行pod spec lint SPFileManager.podspec 确认podspec文件无误

Pod::Spec.new do |s|

  s.name         = "RealmSwiftHelper"
  s.version      = "0.0.1"
  s.summary      = "RealmSwift便捷封装库"

  s.description  = <<-DESC
  对RealmSwift库的封装使用，避免每次使用Realm时，都要写重复的代码。
                   DESC

  s.homepage     = "https://github.com/SwiftPartner"

  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "ryan" => "mob_developer@163.com" }
  s.social_media_url   = "https://www.jianshu.com/u/ddf4eb832e80"

  s.platform     = :ios
  s.platform     = :ios, "9.0"
  s.swift_version = '4.2'

  s.source       = { :git => "https://github.com/SwiftPartner/RealmSwiftHelper.git", :tag => "#{s.version}" }

  s.source_files  = "Classes", "Classes/**/*.{h,m}"

  # s.exclude_files = "Classes/Exclude"
  # s.public_header_files = "Classes/**/*.h"

  # s.requires_arc = true
  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "RealmSwift"
  s.dependency "RxCocoa"
  s.dependency "RxSwift"

end
