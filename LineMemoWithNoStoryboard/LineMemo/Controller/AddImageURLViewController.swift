//
//  AddImageURLViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - AddImageURLViewController

/// * URL 이미지 추가 뷰컨트롤러

class AddImageURLViewController: UIViewController {
    // MARK: UI

    private let mainView = AddImageURLView()

    // MARK: Properties

    var delegate: SendDataDelegate?

    private var isInputData = false {
        didSet {
            mainView.addImageButton.configureButton(isInputData)
        }
    }

    private var isImageRequested = false {
        didSet {
            DispatchQueue.main.async {
                guard let mainNavigationController = self.navigationController as? MainNavigationController else { return }
                mainNavigationController.indicatorView.checkIndicatorView(self.isImageRequested)
            }
        }
    }

    // MARK: Life Cycle

    override func loadView() {
        view = mainView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension AddImageURLViewController: ViewControllerSetting {
    func configureViewController() {
        title = TitleData.addImageURLView
        RequestImage.shared.delegate = self
        configureTextField()
        configureAddImageButton()
    }

    private func configureTextField() {
        mainView.urlTextField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        mainView.urlTextField.configureTextField(mode: .edit)
        mainView.urlTextField.configureBasicBorder()
    }

    private func configureAddImageButton() {
        mainView.addImageButton.configureButton(false)
        mainView.addImageButton.configureBasicBorder()
        mainView.addImageButton.addTarget(self, action: #selector(addImageButtonPressed(_:)), for: .touchUpInside)
    }

    private func checkInputData() {
        guard let urlText = mainView.urlTextField.text else { return }
        isInputData = !urlText.trimmingCharacters(in: .whitespaces).isEmpty
    }
}

// MARK: - Event

extension AddImageURLViewController {
    @objc func textFieldEditingChanged(_: UITextField) {
        checkInputData()
    }

    @objc func addImageButtonPressed(_: UIButton) {
        view.endEditing(true)
        guard let requestedURL = self.mainView.urlTextField.text else { return }
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
        DispatchQueue.main.async { [weak self] in
            self?.delegate?.sendData(image)
            self?.navigationController?.presentToastView("URL 이미지 등록에 성공했습니다.")
            self?.navigationController?.popViewController(animated: true)
        }
    }

    func requestImageDidError(_: RequestImage, _ error: RequestImageError) {
        isImageRequested = false
        endIgnoringInteractionEvents()
        DispatchQueue.main.async { [weak self] in
            self?.navigationController?.presentToastView("URL 이미지 등록에 실패했습니다.\n\(error.message)")
        }
    }
}
