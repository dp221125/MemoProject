//
//  RequestImageDelegate.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

protocol RequestImageDelegate: class {
    func requestImageDidBegin()
    func requestImageDidFinished()
    func requestImageDidError()
}
