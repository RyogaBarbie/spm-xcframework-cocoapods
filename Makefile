.PHONY: setup_cocoapods
setup_cocoapods:
	./generate_xcframeworks.sh
	sudo find ./build/XCFrameworks/CropViewController.xcframework -name "*.swiftinterface" -exec sed -i -e 's/CropViewController\.//g' {} \;
	sudo find ./build/XCFrameworks/NVActivityIndicatorView.xcframework -name "*.swiftinterface" -exec sed -i -e 's/NVActivityIndicatorView\.//g' {} \;
	sudo find ./build/XCFrameworks/RxRelay.xcframework -name "*.swiftinterface" -exec sed -i -e 's/RxRelay\.//g' {} \;
	sudo find ./build/XCFrameworks/Differentiator.xcframework -name "*.swiftinterface" -exec sed -i -e 's/Differentiator\.//g' {} \;
	sudo find ./build/XCFrameworks/RxDataSources.xcframework -name "*.swiftinterface" -exec sed -i -e 's/Differentiator\.//g' {} \;

	# public typealias ActionStyle = UIKit.UIAlertAction.Styleが
	# public typealias ActionStyle = UIKit.UIAlertStyleに書き変わるから、ここだけ治す必要がある。
	sudo find ./build/XCFrameworks/Action.xcframework -name "*.swiftinterface" -exec sed -i -e 's/Action\.//g' {} \;
	sudo find ./build/XCFrameworks/Action.xcframework -name "*.swiftinterface" -exec sed -i -e 's/UIKit.UIAlertStyle/UIKit.UIAlertAction.Style/g' {} \;

	# SwiftyBeaver.Levelは内部で定義されているので、そのままにする必要があるため、必要なものだけ個別で置換する
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.SwiftyBeaver/SwiftyBeaver/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.BaseDestination/BaseDestination/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.Filter/Filter/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.PathFilterFactory/PathFilterFactory/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.FunctionFilterFactory/FunctionFilterFactory/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.MessageFilterFactory/MessageFilterFactory/g' {} \;
	sudo find ./build/XCFrameworks/SwiftyBeaver.xcframework -name "*.swiftinterface" -exec sed -i -e 's/SwiftyBeaver.SBPlatformDestination/SBPlatformDestination/g' {} \;
	
	sudo find ./build/XCFrameworks/RealmSwift.xcframework -name "*.swiftinterface" -exec sed -i -e 's/Realm\.//g' {} \;
	sudo find ./build/XCFrameworks/RealmSwift.xcframework -name "*.swiftinterface" -exec sed -i -e 's/import Private/import Realm.Private/g' {} \;

	sudo find ./build/XCFrameworks/RealmSwift.xcframework -name "*.swiftinterface" -exec sed -i -e 's/RealmSwift\.//g' {} \;

	sudo rm -rf AppPackage/XCFrameworks
	sudo cp -r build/XCFrameworks AppPackage/XCFrameworks
