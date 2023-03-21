//
//  Umbrella.swift
//  
//
//  Created by yamamura ryoga on 2023/02/25.
//

import Foundation
@_exported import DifferenceKit
@_exported import Nuke

public struct Umbrella {
    public init() {}
    public let str: String = "Umbrella"
    
    @available(iOS 13.0.0, *)
    public func doSomething() async {
        let url = URL(string: "https://googgle.com")!
        let image = try? await Nuke.ImagePipeline.shared.data(for: url)
        print(image)
    }
}

//extension Array: ContentIdentifiable where Element: ContentIdentifiable {
//    @inlinable
//    public var differenceIdentifier: Int {
//        var hasher = Hasher()
//        for element in self {
//            hasher.combine(element.differenceIdentifier)
//        }
//        return hasher.finalize()
//    }
//}
