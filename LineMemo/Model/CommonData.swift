//
//  CommonData.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

final class CommonData {
    static let shared = CommonData()
    private(set) var memoDataList = [MemoData]()
}
