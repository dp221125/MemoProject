//
//  ViewSetting.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/16.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import Foundation

/// * View 설정 메서드 정의 프로토콜
protocol ViewSetting: class {
    func configureView()
    func addSubviews()
    func makeConstraints()
}
