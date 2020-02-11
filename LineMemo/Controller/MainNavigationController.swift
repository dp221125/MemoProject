//
//  MainNavigationController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class MainNavigationController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    func reloadMainMemoList() {
        guard let mainViewController = self.viewControllers.first as? MainMemoViewController else { return }
        DispatchQueue.main.async {
            mainViewController.tableView.reloadData()
        }
    }

    @objc func keyboardWillShow(_ sender: NSNotification) {
        if let keyboardSize = (sender.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            topViewController?.view.frame.origin.y = -keyboardSize.height / 2
        }
    }

    @objc func keyboardWillHide(_: NSNotification) {
        topViewController?.view.frame.origin.y = 0
    }
}
