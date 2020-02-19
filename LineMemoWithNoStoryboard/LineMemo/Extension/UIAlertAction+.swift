//
//  UIAlertAction+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/19.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIAlertAction {
    func activateXCTIdentifier(_ identifier: String) {
        accessibilityLabel = identifier
        isAccessibilityElement = true
    }
}
