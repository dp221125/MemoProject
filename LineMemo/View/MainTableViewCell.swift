//
//  MainTableViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainTableViewCell: UITableViewCell {
    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var subTextLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    func configureCell(_ memoData: MemoData) {
        mainTitleLabel.text = memoData.title
        subTextLabel.text = memoData.subText

        guard let thumbnailImage = memoData.imageList.first else { return }
        thumbnailImageView.image = thumbnailImage
    }
}
