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
        let insetView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: frame.size.height))
        leftView = insetView
        leftViewMode = .always

        switch editingMode {
        case .view:
            borderStyle = .none
            removeBorder()
            isEnabled = false
        case .edit:
            configureBasicBorder()
            isEnabled = true
        }
    }
}
