//
//  MainNavigationController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - MainNavigationController

/// * 메인 네비게이션 컨트롤러
class MainNavigationController: UINavigationController {
    // MARK: Life Cycle

    override init(rootViewController: UIViewController) {
        super.init(rootViewController: rootViewController)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension MainNavigationController: ViewControllerSetting {
    func configureViewController() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(_:)), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.navigationBar.tintColor = .black
    }

    func reloadMainMemoList() {
        guard let mainViewController = self.viewControllers.first as? MainMemoViewController else { return }
        mainViewController.reloadMemoData()
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
