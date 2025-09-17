//
//  UIColor+Extension.swift
//  Agent310
//
//  Created by Gauravkumar Gudaliya on 14/06/18.
//  Copyright © 2018 WhollySoftware. All rights reserved.
//

import UIKit

public extension UIColor {
    
    convenience init(hex: String) {
          var hexString = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
          
          if hexString.hasPrefix("#") {
              hexString.removeFirst()
          }
          
          var rgbValue: UInt64 = 0
          Scanner(string: hexString).scanHexInt64(&rgbValue)
          
          self.init(
              red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
              green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
              blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
              alpha: 1.0
          )
      }
//    static let appColor = UIColor(hex: 0x279989)
//    static let appOffGray = UIColor(hex: 0x979797)
//    static let appPurpleLight = UIColor(hex: 0x5D3A7C)
//    static let appOffWhite = UIColor(hex: 0xF4F4F8)
//    static let appDarkWhite = UIColor(hex: 0xDEDEE2)
//
//    convenience init(hex:Int, alpha:CGFloat = 1.0) {
//        self.init(
//            red:   CGFloat((hex & 0xFF0000) >> 16) / 255.0,
//            green: CGFloat((hex & 0x00FF00) >> 8)  / 255.0,
//            blue:  CGFloat((hex & 0x0000FF) >> 0)  / 255.0,
//            alpha: alpha
//        )
//    }
}


