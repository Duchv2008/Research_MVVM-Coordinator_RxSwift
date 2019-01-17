//
//  UIStoryboard+Extension.swift
//  CoreProject
//
//  Created by ha.van.duc on 1/7/19.
//  Copyright © 2019 ha.van.duc. All rights reserved.
//

import UIKit

extension UIStoryboard {
    static func viewController(identifier: String, storyboard: StoryboardName = .Main) -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard.rawValue, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifier)
    }
}
