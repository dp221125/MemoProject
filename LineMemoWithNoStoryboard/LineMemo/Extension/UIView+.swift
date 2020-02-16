//
//  UIView++.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIView {
    
    var safeAreaTopAnchor: NSLayoutYAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.topAnchor
      }
      return self.topAnchor
    }

    var safeAreaLeftAnchor: NSLayoutXAxisAnchor {
      if #available(iOS 11.0, *){
        return self.safeAreaLayoutGuide.leftAnchor
      }
      return self.leftAnchor
    }

    var safeAreaRightAnchor: NSLayoutXAxisAnchor {
      if #available(iOS 11.0, *){
        return self.safeAreaLayoutGuide.rightAnchor
      }
      return self.rightAnchor
    }

    var safeAreaBottomAnchor: NSLayoutYAxisAnchor {
      if #available(iOS 11.0, *) {
        return self.safeAreaLayoutGuide.bottomAnchor
      }
      return self.bottomAnchor
    }
    
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
