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
        DispatchQueue.main.async { [weak self] in
            guard let view = self?.view else { return }
            ToastView.shared.presentShortMessage(view, message: message)
        }
    }
}
