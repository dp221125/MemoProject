//
//  AddImageCollectionViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MemoImageCollectionViewCell

/// * 메모 이미지 컬렉션뷰 셀
class MemoImageCollectionViewCell: UICollectionViewCell {
    // MARK: UI

    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var deleteImageView: UIImageView!

    // MARK: Initializer

    override func awakeFromNib() {
        super.awakeFromNib()
        photoImageView.configureBasicBorder()
        deleteImageView.alpha = 0.8
    }

    // MARK: Configuration

    func configureCell(image: UIImage, imageMode: MemoMode, indexPath: IndexPath) {
        switch imageMode {
        case .view:
            photoImageView.backgroundColor = .black
            deleteImageView.isHidden = true
        case .edit:
            photoImageView.backgroundColor = indexPath.row == 0 ? .clear : .black
            deleteImageView.isHidden = indexPath.row == 0 ? true : false
        }
        photoImageView.image = image
    }
}
