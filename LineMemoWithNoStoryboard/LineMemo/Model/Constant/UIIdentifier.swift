//
//  UIIdentifier.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

/// * UI 식별자
struct UIIdentifier {
    struct Nib {
        struct TableViewCell {
            static let mainMemo = "MainMemoTableViewCell"
        }

        struct CollectionViewCell {
            static let memoImage = "MemoImageCollectionViewCell"
        }
    }

    struct Cell {
        struct Table {
            static let main = "MainMemoTableViewCell"
        }

        struct Collection {
            static let memoImage = "MemoImageCollectionViewCell"
        }
    }
}
