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
//        self.textContainerInset = UIEdgeInsets(
//            top: 20,
//            left: -self.textContainer.lineFragmentPadding,
//            bottom: 0,
//            right: -self.textContainer.lineFragmentPadding
//        )
//
//        self.contentInset = UIEdgeInsets(
//            top: 0,
//            left: 10,
//            bottom: 0,
//            right: -10
//        )

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
