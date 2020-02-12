//
//  MainMemoTableViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainMemoTableViewCell: UITableViewCell {
    // MARK: UI

    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var subTextLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    // MARK: Life Cycle

    override func awakeFromNib() {
        super.awakeFromNib()
    }

    // MARK: Configuration

    func configureCell(_ memoData: MemoData) {
        thumbnailImageView.layer.cornerRadius = 5

        mainTitleLabel.text = memoData.title
        subTextLabel.text = memoData.subText

        guard let thumbnailImage = memoData.imageList.first else {
            thumbnailImageView.image = nil
            return
        }
        thumbnailImageView.image = thumbnailImage
    }
}
