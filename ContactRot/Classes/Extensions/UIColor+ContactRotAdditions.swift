//
//  UIColor+ContactRotAdditions.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

extension UIColor {

    static func alphaForDate(_ date: Date) -> CGFloat {
        let minAlpha = 0.2 as CGFloat
        let dateInterval = CGFloat(abs(date.timeIntervalSinceNow))
        let halfYearInterval = CGFloat(Date.DateInterval.HalfYear.rawValue)
        let calculatedAlpha = 1.0 - (dateInterval / halfYearInterval)

        return fmax(calculatedAlpha, minAlpha)
    }

}
