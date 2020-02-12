//
//  CanSendData.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

/// * ViewController 간 데이터 전송 목적 프로토콜
protocol SendDataDelegate: class {
    func sendData<T>(_ data: T)
}
