//
//  UIIdentifier.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

struct UIIdentifier {
    struct Cell {
        struct Table {
            static let main = "MainTableViewCell"
        }

        struct Collection {
            static let memoImage = "MemoImageCollectionViewCell"
        }
    }

    struct Nib {
        static let memoImageCollectionViewCell = "MemoImageCollectionViewCell"
    }

    struct Storyboard {
        static let main = "Main"
        static let mainNavigationController = "MainNavigationController"
        static let addURLImageNavigationController = "AddURLImageNavigationController"
    }

    struct Segue {
        static let goToAddMemoView = "goToAddMemoView"
        static let goToDetailMemoView = "goToDetailMemoView"
        static let goToAddURLImageView = "goToAddURLImageView"
        static let unwindToAddMemoView = "unwindToAddMemoView"
    }
}
