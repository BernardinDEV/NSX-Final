//
//  Extensions.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import UIKit

extension CGFloat {
    func increase(by percent: CGFloat) -> CGFloat {
        return self + (self * abs(percent) / 100)
    }
    func decrease(by percent: CGFloat) -> CGFloat {
        return self - (self * (abs(percent) / 100))
    }
}
