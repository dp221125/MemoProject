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
            removeBorder()
            isEditable = false
        case .edit:
            configureBasicBorder()
            isEditable = true
        }

        guard let text = self.text else { return }
        if text.trimmingCharacters(in: .whitespaces).isEmpty {
            textColor = .lightGray
            self.text = "메모 내용을 입력해주세요."
        } else {
            textColor = .black
        }
    }
}
