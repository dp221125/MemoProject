//
//  MemoRawData.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct MemoRawData: Codable {
    var title: String
    var subText: String
    var imageDataList: [Data]

    init(title: String = "Title", subText: String = "Sub Text", imageDataList: [Data] = []) {
        self.title = title
        self.subText = subText
        self.imageDataList = imageDataList
    }

    func getMemoData() -> MemoData {
        var imageList = [UIImage]()
        imageList = imageDataList.compactMap { UIImage(data: $0) }
        return MemoData(title: title, subText: subText, imageList: imageList)
    }
}
