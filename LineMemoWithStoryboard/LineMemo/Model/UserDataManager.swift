//
//  UserDataManager.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

// MARK: - UserDataManager

/// * 유저 메모정보 관리자 Singleton Class
final class UserDataManager {
    static let shared = UserDataManager()

    // MARK: Properties

    private let userDefaults = UserDefaults.standard
    private(set) var memoDataList = [MemoData]()
    private(set) var editingMemoIndex: Int = 0

    enum DataKey {
        case memoList

        var keyString: String {
            switch self {
            case .memoList: return "MemoDataList"
            }
        }
    }

    // MARK: Initializer

    private init() {}
}

// MARK: - Configuration

extension UserDataManager {
    func save(_ data: MemoRawData) throws {
        var dataList = try load()
        dataList.append(data)
        try save(dataList)
    }

    private func save(_ dataList: [MemoRawData]) throws {
        do {
            let data = try PropertyListEncoder().encode(dataList)
            userDefaults.set(data, forKey: UserDataManager.DataKey.memoList.keyString)
            loadMemoDataList()
        } catch {
            throw UserDataError.saveFailed
        }
    }

    private func load() throws -> [MemoRawData] {
        guard let data = userDefaults.value(forKey: UserDataManager.DataKey.memoList.keyString) as? Data else { return [] }
        do {
            let memoRawDataList = try PropertyListDecoder().decode([MemoRawData].self, from: data)
            memoDataList = memoRawDataList.compactMap { $0.getMemoData() }
            return memoRawDataList
        } catch {
            throw UserDataError.loadFailed
        }
    }

    func loadMemoDataList() {
        guard let data = userDefaults.value(forKey: UserDataManager.DataKey.memoList.keyString) as? Data,
            let memoRawDataList = try? PropertyListDecoder().decode([MemoRawData].self, from: data) else { return }
        memoDataList = memoRawDataList.compactMap { $0.getMemoData() }
    }

    func remove(at index: Int) throws {
        do {
            var dataList = try load()
            dataList.remove(at: index)
            try save(dataList)
        } catch {
            throw UserDataError.removeFailed
        }
    }

    func configureEditingMemoIndex(at index: Int) {
        editingMemoIndex = index
    }

    func updateMemoData(memoData: MemoData, at index: Int) throws {
        memoDataList[index] = memoData
        let dataList = memoDataList.compactMap { $0.getRawData() }
        do {
            try save(dataList)
        } catch {
            throw UserDataError.saveFailed
        }
    }

    func addMemoData(_ memoData: MemoData) throws {
        memoDataList.append(memoData)
        let dataList = memoDataList.compactMap { $0.getRawData() }
        do {
            try save(dataList)
        } catch {
            throw UserDataError.saveFailed
        }
    }
}
