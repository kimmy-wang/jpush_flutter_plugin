#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
Pod::Spec.new do |s|
  s.name             = 'jpush_flutter_plugin_ios'
  s.version          = '0.0.1'
  s.summary          = 'An iOS implementation of the jpush_flutter_plugin plugin.'
  s.description      = <<-DESC
  An iOS implementation of the jpush_flutter_plugin plugin.
                       DESC
  s.homepage         = 'http://kimmy.me'
  s.license          = { :type => 'MIT', :file => '../LICENSE' }
  s.author           = { 'Kimmy' => 'hi@kimmy.me' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*.{h,m}'
  s.public_header_files = 'Classes/**/*.h'
  s.module_map = 'Classes/JpushFlutterPluginPlugin.modulemap'
  s.dependency 'Flutter'
  s.dependency 'JCore'
  s.dependency 'JPush'
  s.static_framework = true
  s.platform = :ios, '12.0'
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
end
