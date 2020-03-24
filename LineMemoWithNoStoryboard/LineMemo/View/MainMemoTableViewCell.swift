//
//  MainMemoTableViewCell.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MainMemoTableViewCell

/// * 메모 리스트 테이블뷰 셀
class MainMemoTableViewCell: UITableViewCell {
    // MARK: UI

    @IBOutlet var mainTitleLabel: UILabel!
    @IBOutlet var subTextLabel: UILabel!
    @IBOutlet var thumbnailImageView: UIImageView!

    // MARK: Initializer

    override func awakeFromNib() {
        super.awakeFromNib()
        thumbnailImageView.layer.cornerRadius = ViewSize.CornerRadius.thumbnailImageView
    }

    // MARK: Configuration

    func configureCell(_ memoData: MemoData) {
        mainTitleLabel.text = memoData.title
        subTextLabel.text = memoData.subText

        guard let thumbnailImage = memoData.imageList.first else {
            thumbnailImageView.image = nil
            return
        }
        thumbnailImageView.image = thumbnailImage
    }
}
