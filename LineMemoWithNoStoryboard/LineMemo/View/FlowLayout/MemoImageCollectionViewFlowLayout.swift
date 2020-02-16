//
//  MemoImageCollectionViewFlowLayout.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MemoImageCollectionViewFlowLayout

/// * 이미지 컬렉션뷰 FlowLayout 정의
class MemoImageCollectionViewFlowLayout: UICollectionViewFlowLayout {
    override func prepare() {
        super.prepare()
        guard let collectionViewHeight = self.collectionView?.layer.bounds.height else { return }
        sectionInset = UIEdgeInsets(top: -10, left: 10, bottom: -10, right: 30)
        scrollDirection = .horizontal
        collectionView?.isScrollEnabled = true
        let newItemWidth = collectionViewHeight * 0.9
        let newItemSize = CGSize(width: newItemWidth, height: newItemWidth)
        itemSize = newItemSize
    }
}
