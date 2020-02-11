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
    private(set) var editingMemoIndex: Int = 0

    func configureEditingMemoIndex(at index: Int) {
        editingMemoIndex = index
    }

    func addMemoData(_ memoData: MemoData) {
        memoDataList.append(memoData)
    }

    func removeMemoData(at index: Int) {
        if index >= memoDataList.count { return }
        memoDataList.remove(at: index)
    }

    func updateMemoData(_ memoData: MemoData, at index: Int) {
        if index >= memoDataList.count { return }
        memoDataList[index] = memoData
    }
}
