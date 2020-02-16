//
//  UIActivityIndicatorView+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIActivityIndicatorView {
    func checkIndicatorView(_ isRequested: Bool) {
        if isRequested {
            startAnimating()
        } else {
            stopAnimating()
        }
    }
}
