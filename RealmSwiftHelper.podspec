# 执行pod spec lint SPFileManager.podspec 确认podspec文件无误

Pod::Spec.new do |s|

  s.name = 'RealmSwiftHelper'
  s.version = '0.0.2'
  s.summary = 'RealmSwift便捷封装库'
  s.homepage = 'https://github.com/SwiftPartner'
  s.license = 'MIT'
  s.author = { "ryan" => "mob_developer@163.com" }
  s.social_media_url = "https://www.jianshu.com/u/ddf4eb832e80"
  s.ios.deployment_target = '9.0'
  s.swift_version = '4.2'
  s.source = { :git => "https://github.com/SwiftPartner/RealmSwiftHelper.git", :tag => "#{s.version}" }
  s.source_files  = "Classes", "Classes/**/*.swift"
  s.dependency "RealmSwift", '~> 3.14.1'
  s.dependency "RxCocoa", '~> 4.5.0'
  s.dependency "RxSwift", '~> 4.0'

end
