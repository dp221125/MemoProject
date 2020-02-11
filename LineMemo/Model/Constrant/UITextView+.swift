//
//  UITextView_.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UITextView {
    func configureTextView(mode editingMode: MemoMode) {
        switch editingMode {
        case .view:
            layer.borderWidth = 0
            isEditable = false
        case .edit:
            configureBasicBorder()
            isEditable = true
        }
    }
}
