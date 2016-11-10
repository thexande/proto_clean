//
//  ImageHelper.swift
//  proto
//
//  Created by Alexander Murphy on 11/2/16.
//  Copyright © 2016 Alexander Murphy. All rights reserved.
//

import Foundation
import UIKit

class ImageHelper {
    static func circleCrop(imageView: UIImageView) {
        imageView.layer.borderWidth = 1
        imageView.layer.masksToBounds = false
        imageView.layer.cornerRadius = imageView.frame.height / 2
        imageView.clipsToBounds = true
    }
}
