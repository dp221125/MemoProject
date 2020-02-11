//
//  AddImageCollectionViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MemoImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var photoImageView: UIImageView!
    @IBOutlet var deleteImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Method

    func configureCell(image: UIImage, isFirstItem: Bool, imageMode: ImageMode) {
        switch imageMode {
        case .view:
            deleteImageView.isHidden = true
        case .edit:
            deleteImageView.isHidden = isFirstItem ? true : false
            deleteImageView.isHidden = isFirstItem
        }
        photoImageView.image = image
    }
}
