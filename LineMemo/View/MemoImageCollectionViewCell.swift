//
//  AddImageCollectionViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MemoImageCollectionViewCell: UICollectionViewCell {
    @IBOutlet var imageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Method

    func configureCell(_ image: UIImage?) {
        guard let image = image else { return }
        imageView.image = image
    }
}
