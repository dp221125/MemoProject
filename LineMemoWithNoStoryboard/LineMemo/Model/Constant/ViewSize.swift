//
//  ViewSize.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

/// *  뷰 크기 정의
struct ViewSize {
    static let basicSpacing: CGFloat = 10
    static let basicInset: CGFloat = 10

    struct Height {
        static let titleLabel: CGFloat = 30
        static let textField: CGFloat = 50
        static let button: CGFloat = 50
        static let imageCollectionView: CGFloat = 170
        static let imageSection: CGFloat = basicSpacing * 2 + titleLabel + imageCollectionView
        static let mainTableView: CGFloat = 100
    }

    struct CornerRadius {
        static let basic: CGFloat = 10
        static let thumbnailImageView: CGFloat = 5
    }

    struct BorderWidth {
        static let basic: CGFloat = 1
    }
}
