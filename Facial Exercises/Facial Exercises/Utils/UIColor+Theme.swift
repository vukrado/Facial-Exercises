//
//  UIColor+Theme.swift
//  Facial Exercises
//
//  Created by Simon Elhoej Steinmejer on 03/01/19.
//  Copyright © 2019 Vuk Radosavljevic. All rights reserved.
//

import UIKit

extension UIColor {
    static func rgb(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
    
    //app colors here
    static let selectedGreen = UIColor.rgb(red: 76, green: 185, blue: 68)
    static let turquoise = UIColor.rgb(red: 67, green: 206, blue: 162)
    static let waveBlue = UIColor.rgb(red: 24, green: 90, blue: 157)
    static let grayBlue = UIColor.rgb(red: 142, green: 158, blue: 171)
    static let extraLightGray = UIColor.rgb(red: 238, green: 242, blue: 243)
}

extension UIView {
    func setGradientBackground(colors: [CGColor], locations: [NSNumber], startPoint: CGPoint, endPoint: CGPoint) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = colors
        gradientLayer.locations = locations
        gradientLayer.startPoint = startPoint
        gradientLayer.endPoint = endPoint
        
        layer.insertSublayer(gradientLayer, at: 0)
    }
}

enum Appearance {
    static func appFont(style: UIFont.TextStyle, size: CGFloat) -> UIFont {
        let font = UIFont(name: "Merriweather-Regular", size: size)!
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
    
    static func boldAppFont(style: UIFont.TextStyle, size: CGFloat) -> UIFont {
        let font = UIFont(name: "Merriweather-Bold", size: size)!
        return UIFontMetrics(forTextStyle: style).scaledFont(for: font)
    }
}
