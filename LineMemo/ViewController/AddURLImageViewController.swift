//
//  AddURLImageViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class AddURLImageViewController: UIViewController {
    // MARK: UI

    @IBOutlet var textField: UITextField!
    @IBOutlet var addImageButton: UIButton!
    @IBOutlet var indicatorView: UIActivityIndicatorView!

    // MARK: Properties

    private var isInputData = false {
        didSet {
            addImageButton.isEnabled = isInputData
        }
    }

    private var isImageRequested = false {
        didSet {
            DispatchQueue.main.async {
                self.indicatorView.checkIndicatorView(self.isImageRequested)
            }
        }
    }

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTextField()
        configureAddImageButton()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        RequestImage.shared.delegate = self
    }

    // MARK: - Configuration

    private func configureTextField() {
        textField.addTarget(self, action: #selector(textFieldEditingChanged(_:)), for: .editingChanged)
        textField.configureBasicBorder()
    }

    private func configureAddImageButton() {
        addImageButton.configureBasicBorder()
    }

    private func sendImageDataToParentView(_ image: UIImage?) {
        performSegue(withIdentifier: UIIdentifier.Segue.unwindToAddMemoView, sender: image)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let image = sender as? UIImage,
            let addMemoViewController = segue.destination as? AddMemoViewController else { return }
        addMemoViewController.addImage(image)
    }

    // MARK: - Normal

    private func checkInputData() {
        guard let urlText = textField.text else { return }
        isInputData = !urlText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Event

    @objc func textFieldEditingChanged(_: UITextField) {
        checkInputData()
    }

    @IBAction func cancelBarButtonItemPressed(_: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addImageButtonPressed(_: UIButton) {
        guard let requestedURL = self.textField.text else { return }
        RequestImage.shared.requestFromURL(requestedURL) { success, image in
            if success {
                DispatchQueue.main.async {
                    self.sendImageDataToParentView(image)
                    self.dismiss(animated: true, completion: nil)
                }
            }
        }
    }
}

extension AddURLImageViewController: RequestImageDelegate {
    func requestImageDidBegin() {
        isImageRequested = true
        beginIgnoringInteractionEvents()
    }

    func requestImageDidFinished() {
        isImageRequested = false
        endIgnoringInteractionEvents()
    }

    func requestImageDidError() {
        isImageRequested = false
        endIgnoringInteractionEvents()
    }
}
