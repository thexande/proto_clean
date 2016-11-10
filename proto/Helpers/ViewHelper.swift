//
//  ViewHelper.swift
//  proto
//
//  Created by Alexander Murphy on 11/2/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class ViewHelper {
    static func circleCrop(view: UIView) {
        view.layer.borderWidth = 1
        view.layer.masksToBounds = false
        view.layer.cornerRadius = view.frame.height / 2
        view.clipsToBounds = true
    }
}
