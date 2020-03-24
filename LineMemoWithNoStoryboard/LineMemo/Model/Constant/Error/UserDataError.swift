//
//  UserDataError.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/15.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

/// * 유저데이터 에러
enum UserDataError: Error {
    case loadFailed
    case saveFailed
    case removeFailed

    var message: String {
        switch self {
        case .loadFailed: return "Load Failed"
        case .saveFailed: return "Save Failed"
        case .removeFailed: return "Remove Failed"
        }
    }
}
