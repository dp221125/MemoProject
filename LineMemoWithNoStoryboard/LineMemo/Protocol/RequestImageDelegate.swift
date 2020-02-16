//
//  RequestImageDelegate.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

/// * RequestImage 델리게이트
protocol RequestImageDelegate: class {
    func requestImageDidBegin(_ imageRequest: RequestImage)
    func requestImageDidFinished(_ imageRequest: RequestImage, _ image: UIImage)
    func requestImageDidError(_ imageRequest: RequestImage, _ error: RequestImageError)
}
