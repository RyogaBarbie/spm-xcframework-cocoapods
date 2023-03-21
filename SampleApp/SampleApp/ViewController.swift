//
//  ViewController.swift
//  SampleApp
//
//  Created by yamamura ryoga on 2023/02/25.
//

import UIKit
import Umbrella

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        print(Umbrella().str)
        Task.detached {
//            await Umbrella().doSomething()
            let url = URL(string: "https://googgle.com")!
            let image = try? await Nuke.ImagePipeline.shared.data(for: url)
            print(image)
        }
    }
}

extension Array: ContentIdentifiable where Element: ContentIdentifiable {
    @inlinable
    public var differenceIdentifier: Int {
        var hasher = Hasher()
        for element in self {
            hasher.combine(element.differenceIdentifier)
        }
        return hasher.finalize()
    }
}
