//
//  UIViewController+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit


// MARK: - Event

extension UIViewController {
    func presentAlbumAuthRequestAlertController() {
        DispatchQueue.main.async { [weak self] in
            self?.presentAuthRequestAlertController(title: "앨범 접근권한 필요", message: "앨범사용을 위해 앨범 접근권한이 필요합니다.")
        }
    }

    func presentCameraAuthRequestAlertController() {
        DispatchQueue.main.async { [weak self] in
            self?.presentAuthRequestAlertController(title: "카메라 권한 필요", message: "사진촬영을 위해 카메라 권한을 허용해주세요.")
        }
    }

    func presentAuthRequestAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertController.isAccessibilityElement = true

        let getAuthAction = UIAlertAction(title: "네", style: .default) { _ in
            if let appSettingURL = URL(string: UIApplication.openSettingsURLString) {
                UIApplication.shared.open(appSettingURL, options: [:], completionHandler: nil)
            }
        }

        let denyAuthAction = UIAlertAction(title: "아니요", style: .cancel, handler: nil)
        alertController.addAction(getAuthAction)
        alertController.addAction(denyAuthAction)
        present(alertController, animated: true, completion: nil)
    }

    func presentTwoButtonAlertController(title: String, message: String, completion: @escaping (Bool) -> Void) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let approvalAction = UIAlertAction(title: "네", style: .default) { _ in
            completion(true)
        }

        let denyAction = UIAlertAction(title: "아니오", style: .cancel) { _ in
            completion(false)
        }

        alertController.addAction(approvalAction)
        alertController.addAction(denyAction)
        present(alertController, animated: true, completion: nil)
    }

    func endIgnoringInteractionEvents() {
        DispatchQueue.main.async {
            if UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.endIgnoringInteractionEvents()
            }
        }
    }

    func beginIgnoringInteractionEvents() {
        DispatchQueue.main.async {
            if !UIApplication.shared.isIgnoringInteractionEvents {
                UIApplication.shared.beginIgnoringInteractionEvents()
            }
        }
    }

    func presentViewController(destination viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}
