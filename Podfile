# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'
platform :macos, '10.12'
target 'proxy_conf_helper' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for proxy_conf_helper
  pod 'BRLOptionParser', '~> 0.3.1'
end

target 'ShadowsocksX-NG' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for ShadowsocksX-NG
  pod 'Alamofire', '~> 4.7.2'
  pod "GCDWebServer", "~> 3.0"
  pod 'MASShortcut', '~> 2'
  pod 'Masonry'
  # https://github.com/ReactiveX/RxSwift/blob/master/Documentation/GettingStarted.md
  pod 'RxSwift',    '~> 4.5.0'
  pod 'RxCocoa',    '~> 4.5.0'
  target 'ShadowsocksX-NGTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
