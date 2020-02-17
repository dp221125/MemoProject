//
//  AddURLImageViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - AddURLImageViewController

/// * URL 이미지 추가 뷰컨트롤러

class AddImageURLViewController: UIViewController {
    // MARK: UI

    @IBOutlet var textField: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    var delegate: SendDataDelegate?

    private var isInputData = false {
        didSet {
            addImageButton.configureButton(isInputData)
        }
    }

    private var isImageRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isImageRequested)
            }
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension AddImageURLViewController: ViewControllerSetting {
    func configureViewController() {
        RequestImage.shared.delegate = self
        configureTextField()
        configureAddImageButton()
    }

    private func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.configureBasicBorder()
    }

    private func configureAddImageButton() {
        addImageButton.configureButton(false)
        addImageButton.configureBasicBorder()
    }

    private func checkInputData() {
        guard let urlText = textField.text else { return }
        isInputData = !urlText.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - Event

extension AddImageURLViewController {
    @objc func textFieldEditingChanged(_: UITextField) {
        checkInputData()
    }

    @IBAction func cancelBarButtonItemPressed(_: UIBarButtonItem) {
        view.endEditing(true)
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addImageButtonPressed(_: UIButton) {
        view.endEditing(true)
        guard let requestedURL = self.textField.text else { return }
        RequestImage.shared.requestFromURL(requestedURL)
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - RequestImageDelegate

extension AddImageURLViewController: RequestImageDelegate {
    func requestImageDidBegin(_: RequestImage) {
        isImageRequested = true
        beginIgnoringInteractionEvents()
    }

    func requestImageDidFinished(_: RequestImage, _ image: UIImage) {
        isImageRequested = false
        endIgnoringInteractionEvents()
        DispatchQueue.main.async {
            self.delegate?.sendData(image)
            self.navigationController?.presentToastView("URL 이미지 등록에 성공했습니다.")
            self.navigationController?.popViewController(animated: true)
        }
    }

    func requestImageDidError(_: RequestImage, _ error: RequestImageError) {
        isImageRequested = false
        endIgnoringInteractionEvents()
        DispatchQueue.main.async {
            self.navigationController?.presentToastView("URL 이미지 등록에 실패했습니다.\n\(error.message)")
        }
    }
}
