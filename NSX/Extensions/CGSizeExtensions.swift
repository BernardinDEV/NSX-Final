//
//  CGSizeExtensions.swift
//  NSX
//
//  Created by bernardo frisso on 03/07/21.
//

import Foundation
import UIKit

extension CGSize {

    /*
     * Calculate height proportion to max width with given new width and height
     */
    static func sizeProportion(maxWidth: CGFloat, withGivenWidth givenWidth: CGFloat, andHeight givenHeight: CGFloat) -> CGSize {

        let greaterOperand = givenWidth >= givenHeight ? givenWidth : givenHeight
        let lowerOperand = givenWidth <= givenHeight ? givenWidth : givenHeight

        let decrease = greaterOperand - lowerOperand
        let percent: CGFloat = decrease / greaterOperand * 100

        var height = maxWidth.decrease(by: percent)

        if greaterOperand == givenHeight {
            height = maxWidth.increase(by: percent)
        }

        return CGSize(width: maxWidth, height: height)
    }

}
