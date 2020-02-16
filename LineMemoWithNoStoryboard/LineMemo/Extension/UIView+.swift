//
//  UIView++.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - Properties

extension UIView {
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.topAnchor
        }
        return topAnchor
    }

    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.leftAnchor
        }
        return leftAnchor
    }

    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.rightAnchor
        }
        return rightAnchor
    }

    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
        if #available(iOS 11.0, *) {
            return self.safeAreaLayoutGuide.bottomAnchor
        }
        return bottomAnchor
    }
}

// MARK: - Configuration

extension UIView {
    func configureBasicBorder() {
        clipsToBounds = true
        layer.borderWidth = 1
        layer.cornerRadius = 10
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.borderColor = UIColor.black.cgColor
        })
    }

    func removeBorder() {
        UIView.animate(withDuration: 0.3, animations: {
            self.layer.borderColor = UIColor.clear.cgColor
        })
    }
}
