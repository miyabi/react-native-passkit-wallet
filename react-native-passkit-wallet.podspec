require 'json'
version = JSON.parse(File.read('package.json'))["version"]

Pod::Spec.new do |s|

  s.name            = "react-native-passkit-wallet"
  s.version         = version
  s.homepage        = "https://github.com/miyabi/react-native-passkit-wallet"
  s.summary         = "React Native module to handle PassKit."
  s.license         = "MIT"
  s.author          = "Masayuki Iwai"
  s.platform        = :ios, "9.0"
  s.source          = { :git => "https://github.com/miyabi/react-native-passkit-wallet.git", :tag => "v" + s.version.to_s }
  s.source_files    = "ios/RNPassKit/*.{h,m}"
  s.preserve_paths  = "**/*.js"

  s.dependency 'React'
end
