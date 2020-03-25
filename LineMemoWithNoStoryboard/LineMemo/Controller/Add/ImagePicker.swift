//
//  ImagePicker.swift
//  LineMemo
//
//  Created by Seokho on 2020/03/25.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit
import AVFoundation
import Photos

enum AuthResult {
    case authorized
    case denial
}

class ImagePicker: NSObject {
    
    let controller: UIImagePickerController
    private let viewModel: ImagePikcerViewModelType
    
    init(viewModel: ImagePikcerViewModelType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        self.controller = imagePickerController
        self.viewModel = viewModel
        super.init()
        imagePickerController.delegate = self
    }
    
    func checkCameraAuth(compeltion: @escaping ((AuthResult) -> Void)) {
        let auth = AVCaptureDevice.authorizationStatus(for: .video)
        switch auth {
        case .authorized:
            compeltion(.authorized)
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if granted {
                    compeltion(.authorized)
                }
            })
        default:
            compeltion(.denial)
        }
    }
    
    func checkAlbumAuth(compeltion: @escaping ((AuthResult) -> Void)) {
        let albumAuthorizationStatus = PHPhotoLibrary.authorizationStatus()
        
        switch albumAuthorizationStatus {
        case .authorized:
            compeltion(.authorized)
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { status in
                switch status {
                case .authorized:
                    compeltion(.authorized)
                default:
                    compeltion(.denial)
                }
            }
        default:
            compeltion(.denial)
        }
    }
    
    
    func setController(_ type: UIImagePickerController.SourceType) {
        DispatchQueue.main.async {
            self.controller.sourceType = type
        }
        
    }
    
}
extension ImagePicker: UIImagePickerControllerDelegate & UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage,
            let data = selectedImage.pngData() else { return }
        self.viewModel.pickerInputs.data.onNext(data)
        picker.dismiss(animated: true)
    }
}
