# Uncomment the next line to define a global platform for your project
# platform :ios, '9.0'

target 'MarvelApp' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!
  # this is for configuring the marvel api private and public keys to use with api calls
  plugin 'cocoapods-keys', {
    :project => "Marvel",
    :keys => [
    "MarvelApiKey",
    "MarvelPrivateKey"
    ]}
  
  # Pods for MarvelApp
  # Realm for caching marvel list of characters
  pod 'RealmSwift'
  
end
