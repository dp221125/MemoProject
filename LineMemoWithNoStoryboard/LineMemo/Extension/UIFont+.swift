//
//  UIFont+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/16.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIFont {
    static func mainFont(displaySize: CGFloat = 18) -> UIFont {
        if let mainFont = UIFont(name: "AppleSDGothicNeo-Regular", size: displaySize) {
            return mainFont
        }
        return UIFont()
    }

    static func titleFont(displaySize: CGFloat = 18) -> UIFont {
        if let titleFont = UIFont(name: "AppleSDGothicNeo-Bold", size: displaySize) {
            return titleFont
        }
        return UIFont()
    }

    static func subFont(displaySize: CGFloat = 18) -> UIFont {
        if let subFont = UIFont(name: "AppleSDGothicNeo-Thin", size: displaySize) {
            return subFont
        }
        return UIFont()
    }
}
