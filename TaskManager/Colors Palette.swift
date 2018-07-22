//
//  Colors.swift
//  TaskManager
//
//  Created by Michal Černý on 20/07/2018.
//  Copyright © 2018 Michal Černý. All rights reserved.
//

import Foundation
import UIKit

class ColorsPalette {
    static let lightGreen  = UIColor(rgb: 0xC6DA02)
    static let green       = UIColor(rgb: 0x79A700)
    static let orange      = UIColor(rgb: 0xF68B2C)
    static let brown       = UIColor(rgb: 0xE2B400)
    static let red         = UIColor(rgb: 0xF5522D)
    static let pink        = UIColor(rgb: 0xFF6E83)
    
    static let allColors = [ColorsPalette.green, ColorsPalette.lightGreen, ColorsPalette.orange,
    ColorsPalette.brown, ColorsPalette.red, ColorsPalette.pink]
}

extension UIColor {
    convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
