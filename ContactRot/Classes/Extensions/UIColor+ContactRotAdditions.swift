//
//  UIColor+ContactRotAdditions.swift
//  ContactRot
//
//  Created by Andrew Dempsey on 10/13/17.
//  Copyright © 2017 Dempsey. All rights reserved.
//

import UIKit

extension UIColor {

    static func contactRotBlue() -> UIColor {
        return UIColor(hex: 0x557E97)
    }

    static func contactRotGray() -> UIColor {
        return UIColor(hex: 0x383A3C)
    }

    static func contactRotLightGray() -> UIColor {
        return UIColor(hex: 0xD2D7D9)
    }

    static func contactRotDarkGray() -> UIColor {
        return UIColor(hex: 0x25282A)
    }

    static func contactRotDarkGray(alpha: Int) -> UIColor {
        return UIColor(hex: 0x25282A, alpha: alpha)
    }

    convenience init(r: Int, g: Int, b: Int, a: Int) {
        self.init(red: CGFloat(r) / 255.0,
                  green: CGFloat(g) / 255.0,
                  blue: CGFloat(b) / 255.0,
                  alpha: CGFloat(a) / 255.0)
    }

    convenience init(r: Int, g: Int, b: Int) {
        self.init(r: r, g: g, b: b, a: 255)
    }

    convenience init(hex: Int) {
        self.init(r: (hex >> 16) & 0xFF,
                  g: (hex >> 8) & 0xFF,
                  b: hex & 0xFF)
    }

    convenience init(hex: Int, alpha: Int) {
        self.init(r: (hex >> 16) & 0xFF,
                  g: (hex >> 8) & 0xFF,
                  b: hex & 0xFF,
                  a: alpha)
    }

    static func alphaForDate(_ date: Date) -> CGFloat {
        let minAlpha = 0.2 as CGFloat
        let dateInterval = CGFloat(abs(date.timeIntervalSinceNow))
        let halfYearInterval = CGFloat(Date.DateInterval.HalfYear.rawValue)
        let calculatedAlpha = 1.0 - (dateInterval / halfYearInterval)

        return fmax(calculatedAlpha, minAlpha)
    }

}
