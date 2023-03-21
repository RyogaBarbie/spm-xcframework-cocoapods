source "https://cdn.cocoapods.org/"
platform :ios, "15.0"

use_frameworks! :linkage => :static

workspace './spm-xcframework-cocoapods.xcworkspace'

install! 'cocoapods', deterministic_uuids: false, integrate_targets: false

post_install do |installer|
  installer.pods_project.build_configurations.each do |config|
    config.build_settings["EXCLUDED_ARCHS[sdk=iphonesimulator*]"] = "arm64"
    config.build_settings['DEVELOPMENT_TEAM'] = '3D7489DM9Z'
  end
  installer.pods_project.targets.each do |target|
    if target.respond_to?(:product_type) and target.product_type == "com.apple.product-type.bundle"
      target.build_configurations.each do |config|
        config.build_settings['CODE_SIGNING_ALLOWED'] = 'NO'
      end
    end
  end
  # XCConfig を正しい形に修正
  #
  # 1.
  # integrate_targets: false 設定後に `$ pod install` すると
  # XCConfig に `EMBEDDED_CONTENT_CONTAINS_SWIFT` が追加されて、
  # IPA Archive 時にシンボルが重複して Fail するので削除
  #
  # 2.
  # CocoaPods の Target Integration を無効にしている影響で、
  # `PODS_ROOT` ・ `PODS_PODFILE_DIR_PATH` 変更されてしまうので上書き
  #
  # ref:
  # [Infrastructure] CocoaPods の Workspace 統合を無効化 #4898
  # https://github.com/delyjp/kurashiru-ios/pull/4898
  #
  def update_xcconfig(installer:, target_name:, root_path:, override_exclude_archs:)
    umbrella_targets = installer.aggregate_targets.select { |target| target.name.include?(target_name) }
    umbrella_targets.each do |umbrella_target|
      umbrella_target.user_build_configurations.each do |key, name|
       xcconfig_filename = "#{Dir.pwd}/Pods/Target Support Files/#{umbrella_target.name}/#{umbrella_target.name}.#{key.downcase}.xcconfig"
       xcconfig = File.readlines(xcconfig_filename)

       # EMBEDDED_CONTENT_CONTAINS_SWIFT を書き換え
       xcconfig.delete_if { |line| line.include?('EMBEDDED_CONTENT_CONTAINS_SWIFT') }

       # PODS_PODFILE_DIR_PATH & PODS_ROOT を書き換え
      pods_podfile_dir_path = "PODS_PODFILE_DIR_PATH = #{root_path}\n"
      pods_root = "PODS_ROOT = #{root_path}/Pods\n"
       xcconfig
         .map! { |line| line.include?('PODS_PODFILE_DIR_PATH = ') ? pods_podfile_dir_path: line }
         .map! { |line| line.include?('PODS_ROOT = ') ? pods_root : line }

      # FBAudienceNetworkの`EXCLUDED_ARCHS[sdk=iphonesimulator*] = i386`影響でPod-UmbrellaのEXCLUDED_ARCHS[sdk=iphonesimulator*]がi386になるため
      # ここでフラグがtrueのみ上書きする
       xcconfig.map! { |line| line.include?('EXCLUDED_ARCHS[sdk=iphonesimulator*] = ') ? pods_root : line } if override_exclude_archs

       replaced_xcconfig = xcconfig.join
       File.open(xcconfig_filename, "w") { |f| f.write(replaced_xcconfig) }
      end
    end
  end

  # UmbrellaとKurashiruLineSDKとKurashiruAmazonPublisherSDK
  update_xcconfig(installer: installer, target_name: "Pods-Umbrella", root_path: "${SRCROOT}/../..", override_exclude_archs: true)
  # update_xcconfig(installer: installer, target_name: "Pods-UmbrellaTests", root_path: "${SRCROOT}/../..", override_exclude_archs: true)

  # Firebase Crashlytics の Script（run/upload-symbols）をダウンロード
  # PodBuilder で PreBuild しているので Script が含まれているソースコードが `./Pods` 以下にダウンロードされないため
  # 手動で Script をダウンロードする必要がある
  firebase_version = installer.generated_pod_targets.find { |t| t.name == 'Firebase' }.version
  remote_path = "https://raw.githubusercontent.com/firebase/firebase-ios-sdk/#{firebase_version}/Crashlytics"
  local_path = './Pods/FirebaseCrashlytics'
  Pod::UI.puts "🔥 Dowloading Firebase Crashlytics(v#{firebase_version}) Scripts"
  system("curl --create-dirs --output #{local_path}/run #{remote_path}/run")
  system("curl --create-dirs --output #{local_path}/upload-symbols #{remote_path}/upload-symbols")
  system("chmod -R +x #{local_path}/")
end
abstract_target 'Umbrella' do
  use_frameworks! :linkage => :static

  pod 'Firebase/Core', '10.3.0'
  pod 'Firebase/Messaging', '10.3.0'
  pod 'Firebase/RemoteConfig', '10.3.0'
  pod 'Firebase/Crashlytics', '10.3.0'
  pod 'GoogleAppMeasurement'

  pod "GoogleAnalytics"
  pod 'GoogleTagManager', '7.4.2'

  pod 'Repro'

  pod 'Parchment', podspec: 'Specs/Parchment/Parchment.podspec.json'

  facebook_version = '11.2.1'

  # v9.3.0からkurashiru.xcworkspaceを開くとPods.xcodeproj/project.pbxprojの差分が発生してしまうためバージョンを固定
  # 挙動が戻ったらバージョン固定を外す
  pod 'FBSDKCoreKit', facebook_version

  # objective-c製のライブラリは今後アップデート予定がないためバージョン固定化
  pod "GPUImage", "0.1.7", :inhibit_warnings => true
  pod 'LineKit', '1.4.2'

  pod 'SwiftyBeaver'

  ##### Ads 関連のSDK ↓ #####
  # 基本的に最新バージョンを導入する
  # メジャーアップデートなどがある場合はBP事業部に確認を取る

  pod 'FiveGADAdapter'
  pod 'CriteoPublisherSdk', '4.5.0'

  pod 'Google-Mobile-Ads-SDK'
  pod 'GoogleMobileAdsMediationFacebook'
  # pod 'GoogleMobileAdsMediationPangle', '4.8.0.9.0'
  pod 'GoogleMobileAdsMediationFluct', '6.20.7'

  ##### Ads 関連のSDK ↑ #####
  pod 'AWSCore'
  pod 'AWSKinesis'
  pod 'Alamofire'
  pod 'CropViewController'
  pod 'lottie-ios', '4.1.1'
  pod 'NVActivityIndicatorView'
  pod 'DifferenceKit'
  pod 'FloatingPanel'
  pod 'Nuke', podspec: 'Specs/Nuke/Nuke.podspec'
  pod 'NukeUI', podspec: 'Specs/Nuke/NukeUI.podspec'
  pod 'NukeExtensions', podspec: 'Specs/Nuke/NukeExtensions.podspec'

  pod 'SherlockForms', podspec: 'Specs/SherlockForms/SherlockForms.podspec'
  # pod 'SherlockDebugForms', podspec: 'Specs/SherlockForms/SherlockDebugForms.podspec'
  pod 'SherlockHUD', podspec: 'Specs/SherlockForms/SherlockHUD.podspec'

  pod 'CustomDump', podspec: 'Specs/swift-custom-dump/swift-custom-dump.podspec'
  pod 'XCTestDynamicOverlay', podspec: 'Specs/xctest-dynamic-overlay/xctest-dynamic-overlay.podspec'

  pod 'CasePaths', podspec: 'Specs/swift-case-paths/swift-case-paths.podspec'
  pod 'Actomaton', podspec: 'Specs/Actomaton/Actomaton.podspec'
  pod 'ActomatonUI', podspec: 'Specs/Actomaton/ActomatonUI.podspec'
  pod 'ActomatonStore', podspec: 'Specs/Actomaton/ActomatonStore.podspec'
  pod 'ActomatonDebugging', podspec: 'Specs/Actomaton/ActomatonDebugging.podspec'
  pod 'Runtime', podspec: 'Specs/CombineCocoa/Runtime.podspec'
  pod 'CombineCocoa', podspec: 'Specs/CombineCocoa/CombineCocoa.podspec'

  pod 'Adjust', '4.33.3'
  pod 'Realm', podspec: 'Specs/realm-swift/Realm.podspec'
  pod 'RealmSwift', podspec: 'Specs/realm-swift/RealmSwift.podspec'

  #### SNS連携 ####
  pod 'GoogleSignIn'
  pod 'FBSDKLoginKit', facebook_version

  #### Rx ####
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'Unio'
  pod 'Action'
  pod 'RxDataSources'
  pod 'RxCombine'
end



