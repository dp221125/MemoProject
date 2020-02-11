//
//  MemoData.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

struct MemoData {
    var id: Int
    var title: String
    var subText: String
    var imageList: [UIImage]

    init(id: Int = 0, title: String = "Title", subText: String = "Sub Text", imageList: [UIImage] = []) {
        self.id = id
        self.title = title
        self.subText = subText
        self.imageList = imageList
    }
}
