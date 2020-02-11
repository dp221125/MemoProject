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

    func addMemoData(_ memoData: MemoData) {
        memoDataList.append(memoData)
    }

    func updateMemoData(_ memoData: MemoData, at index: Int) {
        if index >= memoDataList.count { return }
        memoDataList[index] = memoData
    }
}
