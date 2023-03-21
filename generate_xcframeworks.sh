#! /bin/bash

# set -eu

PODS_PROJECT=Pods/Pods.xcodeproj
DESTINATION_IOS_SIMULATOR='generic/platform=iOS Simulator'
DESTINATION_IOS='generic/platform=iOS'
CONFIGURATION=Release
ARCHIVE_PATH_PODS=build/Pods-Archive
ARCHIVE_FILE_IOS_SIMULATOR=iOS-Simulator.xcarchive
ARCHIVE_FILE_IOS=iOS.xcarchive
XCFRAMEWORK_OUTPUT=build/XCFrameworks
PODS_SOURCE=Pods

create-xcframework() {
    scheme_name=$1
    archive_path_ios="$ARCHIVE_PATH_PODS/$scheme_name/$ARCHIVE_FILE_IOS"
    archive_path_ios_simulator="$ARCHIVE_PATH_PODS/$scheme_name/$ARCHIVE_FILE_IOS_SIMULATOR"

    # TODO: 実装終わったら消す
    xcframework="$XCFRAMEWORK_OUTPUT/$scheme_name.xcframework"
    if [ -e $xcframework ]; then
        echo " $scheme_name は成功してるからskip"
    else
        echo -e "\n\n\nCreate XCFramework for $scheme_name..."

        # Build Cocoapods Library for iOS Simulator
        xcodebuild \
            'ENABLE_BITCODE=YES' \
            'BITCODE_GENERATION_MODE=bitcode' \
            'OTHER_CFLAGS=-fembed-bitcode' \
            'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
            'SKIP_INSTALL=NO' \
            archive \
            -project $PODS_PROJECT \
            -scheme $scheme_name \
            -destination "$DESTINATION_IOS_SIMULATOR" \
            -configuration $CONFIGURATION \
            -archivePath $archive_path_ios_simulator \
            -quiet

        # Build Cocoapods Library for iOS Device
        xcodebuild \
            'ENABLE_BITCODE=YES' \
            'BITCODE_GENERATION_MODE=bitcode' \
            'OTHER_CFLAGS=-fembed-bitcode' \
            'BUILD_LIBRARY_FOR_DISTRIBUTION=YES' \
            'SKIP_INSTALL=NO' \
            archive \
            -project $PODS_PROJECT \
            -scheme $scheme_name \
            -destination "$DESTINATION_IOS" \
            -configuration $CONFIGURATION \
            -archivePath $archive_path_ios \
            -quiet

        # Remove Existing XCFramework
        xcframework="$XCFRAMEWORK_OUTPUT/$scheme_name.xcframework"
        if [ -e $xcframework ]; then
            echo "File exists."
            rm -r "$xcframework"
        fi

        if [[ $scheme_name = "lottie-ios" ]]; then
            framework_names=("Lottie")

        elif [[ $scheme_name = "PromisesObjC" ]]; then
            framework_names=("FBLPromises")

        elif [[ $scheme_name = "Firebase" ]]; then
            framework_names=("FBLPromises" "FirebaseABTesting" "FirebaseCore" "FirebaseCoreInternal" "FirebaseCrashlytics" "FirebaseMessaging" "FirebaseRemoteConfig" "GoogleDataTransport")

        elif [[ $scheme_name = "FirebaseAnalytics" ]]; then
            framework_names=("FBLPromises" "FirebaseCore" "FirebaseCoreInternal")

        elif [[ $scheme_name = "FiveGADAdapter" ]]; then
            framework_names=("FBLPromises" "GoogleUtilities")

        elif [[ $scheme_name = "LineSDKSwift" ]]; then
            framework_names=("LineSDK")

        elif [[ $scheme_name = "GoogleTagManager" ]]; then
            framework_names=("FBLPromises" "FirebaseCore" "FirebaseCoreInternal")

        elif [[ $scheme_name = "Ads-Global" ]]; then
            framework_names=("OneKit_Pangle" "RangersAPM_Pangle" "RARegisterKit")

        elif [[ $scheme_name = "RangersAPM-Pangle" ]]; then
            framework_names=("OneKit_Pangle" "RangersAPM_Pangle" "RARegisterKit")

        elif [[ $scheme_name = "RARegisterKit-Pangle" ]]; then
            framework_names=("OneKit_Pangle" "RARegisterKit")

        elif [[ $scheme_name = "OneKit-Pangle" ]]; then
            framework_names=("OneKit_Pangle")

        elif [[ $scheme_name = "RxSwift" ]]; then
            framework_names=("RxSwift")

        elif [[ $scheme_name = "RxDataSources" ]]; then
            framework_names=("RxDataSources")

        elif [[ $scheme_name = "Action" ]]; then
            framework_names=("Action")

        elif [[ $scheme_name = "RxCocoa" ]]; then
            framework_names=("RxCocoa")

        elif [[ $scheme_name = "RxCombine" ]]; then
            framework_names=("RxCombine")

        elif [[ $scheme_name = "RxRelay" ]]; then
            framework_names=("RxRelay")

        elif [[ $scheme_name = "Unio" ]]; then
            framework_names=("Unio")

        elif [[ $scheme_name = "RealmSwift" ]]; then
            framework_names=("RealmSwift")

        elif [[ $scheme_name = "Actomaton" ]]; then
            framework_names=("Actomaton")
        else
            framework_names=($scheme_name)
        fi

        # Create XCFramework
        for framework_name in "${framework_names[@]}"
        do
            xcodebuild \
                -create-xcframework \
                -framework "$archive_path_ios/Products/Library/Frameworks/$framework_name.framework" \
                -framework "$archive_path_ios_simulator/Products/Library/Frameworks/$framework_name.framework" \
                -output "$XCFRAMEWORK_OUTPUT/$scheme_name.xcframework"
        done
    fi
}

# if not including arguments, create all xcframeworks
if [[ $@ = '' ]]; then
    schemes=`xcodebuild \
        -project Pods/Pods.xcodeproj \
        -list |
        tr -d '\n' |
        awk '{sub("^.*Schemes:", ""); print $0}' |
        sed -E 's/Pods[^[:space:]]+//g'`
else
    schemes=$@
fi

for scheme in $schemes
do
    if [[ $scheme = "Repro" ]]; then
        echo "copy XCFramework for Repro"
        Remove Existing XCFramework
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/$scheme/$scheme.xcframework $XCFRAMEWORK_OUTPUT/
    elif [[ $scheme = "FBAudienceNetwork" ]]; then
        echo "copy XCFramework for FBAudienceNetwork"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/$scheme/Static/$scheme.xcframework $XCFRAMEWORK_OUTPUT/
    elif [[ $scheme = "FiveAd" ]]; then
        echo "copy XCFramework for FiveAd"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/$scheme/$scheme.xcframework $XCFRAMEWORK_OUTPUT/

    elif [[ $scheme = "FluctSDK" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/FluctSDK/FluctSDK.embeddedframework/FluctSDK.xcframework $XCFRAMEWORK_OUTPUT/

    elif [[ $scheme = "Google-Mobile-Ads-SDK" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/Google-Mobile-Ads-SDK/Frameworks/GoogleMobileAdsFramework/GoogleMobileAds.xcframework $XCFRAMEWORK_OUTPUT/Google-Mobile-Ads-SDK.xcframework

    elif [[ $scheme = "GoogleAnalytics" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/GoogleAnalytics/Frameworks/GoogleAnalytics.xcframework $XCFRAMEWORK_OUTPUT/

    elif [[ $scheme = "GoogleAppMeasurement" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/GoogleAppMeasurement/Frameworks/GoogleAppMeasurement.xcframework $XCFRAMEWORK_OUTPUT/

    elif [[ $scheme = "GoogleMobileAdsMediationFacebook" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/GoogleMobileAdsMediationFacebook/MetaAdapter-6.12.0.0/MetaAdapter.xcframework $XCFRAMEWORK_OUTPUT/GoogleMobileAdsMediationFacebook.xcframework

    elif [[ $scheme = "GoogleMobileAdsMediationPangle" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/GoogleMobileAdsMediationPangle/PangleAdapter-4.8.0.9.0/PangleAdapter.xcframework $XCFRAMEWORK_OUTPUT/GoogleMobileAdsMediationPangle.xcframework

    elif [[ $scheme = "GoogleUserMessagingPlatform" ]]; then
        echo "copy XCFramework for $scheme"
        rm -r "$XCFRAMEWORK_OUTPUT/$scheme.xcframework"
        cp -r $PODS_SOURCE/GoogleUserMessagingPlatform/Frameworks/Release/UserMessagingPlatform.xcframework $XCFRAMEWORK_OUTPUT/GoogleUserMessagingPlatform.xcframework

    elif [[ $scheme = "AmazonPublisherServicesSDK" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "BUAdSDK" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "BURelyFoundation_Global" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "CropViewController-TOCropViewControllerBundle" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "FBSDKCoreKit-FacebookSDKStrings" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "GoogleSignIn-GoogleSignIn" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "LineSDKSwift-LineSDK" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "SherlockDebugForms" ]]; then
        echo "skip $scheme"

    elif [[ $scheme = "Realm" ]]; then
        echo "skip $scheme"

    else
        create-xcframework $scheme
    fi
done