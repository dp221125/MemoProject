//
//  UINavigationController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/12.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UINavigationController {
    func presentToastView(_ message: String) {
        DispatchQueue.main.async {
            ToastView.shared.presentShortMessage(self.view, message: message)
        }
    }
}
