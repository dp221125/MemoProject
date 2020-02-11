//
//  UITextField+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UITextField {
    func configureTextField(mode editingMode: MemoMode) {
        switch editingMode {
        case .view:
            layer.borderWidth = 0
            isEnabled = false
        case .edit:
            configureBasicBorder()
            isEnabled = true
        }
    }
}
