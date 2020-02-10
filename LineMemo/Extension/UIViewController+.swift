//
//  UIViewController+.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

extension UIViewController {
    func openCamera(_ imagePickerController: UIImagePickerController) {
        DispatchQueue.main.async {
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }
        }
    }

    func presentAuthRequestAlertController(title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
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

    func openAlbum(_ imagePickerController: UIImagePickerController) {
        DispatchQueue.main.async { [weak self] in
            imagePickerController.sourceType = .photoLibrary
            self?.present(imagePickerController, animated: true, completion: nil)
        }
    }
}
