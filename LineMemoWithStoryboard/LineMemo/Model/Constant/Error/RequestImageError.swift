//
//  RequestImageError.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/17.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

/// * 이미지요청 에러
enum RequestImageError: Error {
    case requestFailed
    case invalidURL
    case invalidFormat

    var message: String {
        switch self {
        case .requestFailed: return "Image Request Failed"
        case .invalidURL: return "Invalid URL"
        case .invalidFormat: return "Invalid Image Format"
        }
    }
}
