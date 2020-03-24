//
//  UIButton+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/14.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIButton {
    func configureButton(_ isEnabled: Bool) {
        self.isEnabled = isEnabled
        if isEnabled {
            backgroundColor = .black
        } else {
            backgroundColor = .gray
        }
    }
}
