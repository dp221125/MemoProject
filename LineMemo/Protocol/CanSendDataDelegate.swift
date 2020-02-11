//
//  CanSendData.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

protocol CanSendDataDelegate: class {
    func sendData<T>(_ data: T)
}
