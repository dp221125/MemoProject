//
//  MainNavigationController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - Main

class MainNavigationController: UINavigationController {
    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
}

// MARK: - Configuration

extension MainNavigationController {
    func reloadMainMemoList() {
        guard let mainViewController = self.viewControllers.first as? MainMemoViewController else { return }
        DispatchQueue.main.async {
            mainViewController.tableView.reloadData()
        }
    }
}

// MARK: - Event

extension MainNavigationController {
    @objc func keyboardWillShow(_: NSNotification) {
        topViewController?.view.frame.origin.y = -ViewSize.Height.imageSection
    }

    @objc func keyboardWillHide(_: NSNotification) {
        topViewController?.view.frame.origin.y = 0
    }
}
