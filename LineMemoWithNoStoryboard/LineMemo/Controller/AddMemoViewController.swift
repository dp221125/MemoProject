//
//  AddMemoViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

// MARK: - AddMemoViewController

/// * 메모 추가 뷰컨트롤러
class AddMemoViewController: UIViewController {
    // MARK: UI

    private let mainView = EditMemoView()

    private var addMemoBarButtonItem = UIBarButtonItem()

    private lazy var addImageTapGestureRecognizer = UITapGestureRecognizer()

    private lazy var addImageAlertController: UIAlertController = {
        let addImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)
        return addImageAlertController
    }()

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()

    // MARK: Properties

    private var imageViewList: [UIImage] = [.addImage]

    private var isValidInputData = false {
        didSet {
            addMemoBarButtonItem.isEnabled = isValidInputData
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

extension AddMemoViewController: ViewControllerSetting {
    func configureViewController() {
        title = TitleData.addMemoview
        configureCollectionView()
        configureAlertController()
        configureimagePickerController()
        configureTextField()
        configureTextView()
        configureAddMemoBarButtonItem()
        configureTapGestureRecognizer()
    }

    private func configureTapGestureRecognizer() {
        addImageTapGestureRecognizer.addTarget(self, action: #selector(addImageInCollectionViewCellPressed(_:)))
    }

    private func configureAddMemoBarButtonItem() {
        addMemoBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(addMemoBarButtonItemPressed(_:)))
        addMemoBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = addMemoBarButtonItem
    }

    private func configureimagePickerController() {
        imagePickerController.delegate = self
    }

    private func configureCollectionView() {
        mainView.imageCollectionView.dataSource = self
    }

    private func configureTextView() {
        mainView.subTextView.configureTextView(mode: .edit)
        mainView.subTextView.delegate = self
    }

    private func configureTextField() {
        mainView.titleTextField.configureTextField(mode: .edit)
        mainView.titleTextField.addTarget(self, action: #selector(titleTextEditingChanged(_:)), for: .editingChanged)
    }

    private func configureAlertController() {
        /// * 사진촬영 선택 시 이벤트 정의
        let getCameraAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
            guard let imagePickerController = self?.imagePickerController else { return }
            let cameraType = AVMediaType.video
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: cameraType)
            switch cameraStatus {
            case .authorized:
                self?.openCamera(imagePickerController)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraType, completionHandler: { granted in
                    if granted {
                        self?.openCamera(imagePickerController)
                    }
                })
            default:
                self?.presentCameraAuthRequestAlertController()
            }
        }
        getCameraAlertAction.activateXCTIdentifier(XCTIdentifier.Alert.getCameraAction)

        /// * 앨범사진 선택 시 이벤트 정의
        let getAlbumAlertAction = UIAlertAction(title: "앨범 사진 가져오기", style: .default, handler: { [weak self] _ in
            guard let imagePickerController = self?.imagePickerController else { return }
            let albumAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

            DispatchQueue.main.async {
                switch albumAuthorizationStatus {
                case .authorized:
                    self?.openAlbum(imagePickerController)
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            self?.openAlbum(imagePickerController)
                        default: break
                        }
                    }
                default:
                    self?.presentAlbumAuthRequestAlertController()
                }
            }
        })
        getAlbumAlertAction.activateXCTIdentifier(XCTIdentifier.Alert.getAlbumAction)

        let getPictureFromURLAction = UIAlertAction(title: "URL로 등록하기", style: .default) { _ in
            DispatchQueue.main.async { [weak self] in
                let addImageURLViewController = AddImageURLViewController()
                addImageURLViewController.delegate = self
                self?.presentViewController(destination: addImageURLViewController)
            }
        }
        getPictureFromURLAction.activateXCTIdentifier(XCTIdentifier.Alert.presentAddImageURLViewAction)

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        addImageAlertController.addAction(getCameraAlertAction)
        addImageAlertController.addAction(getAlbumAlertAction)
        addImageAlertController.addAction(getPictureFromURLAction)
        addImageAlertController.addAction(cancelAlertAction)
        cancelAlertAction.activateXCTIdentifier(XCTIdentifier.Alert.cancelAction)
    }

    private func checkInputData() {
        guard let titleText = mainView.titleTextField.text,
            let subText = mainView.subTextView.text else { return }
        isValidInputData = !titleText.trimmingCharacters(in: .whitespaces).isEmpty && (mainView.subTextView.textColor == .black && !subText.trimmingCharacters(in: .whitespaces).isEmpty)
    }

    private func insertAndUpdateImageList(at index: Int, image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.imageViewList.insert(image, at: index)
            self?.mainView.imageCollectionView.performBatchUpdates({
                self?.beginIgnoringInteractionEvents()
                self?.mainView.imageCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            }) { _ in
                self?.endIgnoringInteractionEvents()
            }
        }
    }

    private func removeAndUpdateImageList(at index: Int, mode: UpdateMode) {
        DispatchQueue.main.async { [weak self] in
            self?.imageViewList.remove(at: index)
            switch mode {
            case .single:
                self?.mainView.imageCollectionView.performBatchUpdates({
                    self?.beginIgnoringInteractionEvents()
                    self?.mainView.imageCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }) { _ in
                    self?.endIgnoringInteractionEvents()
                }
            case .whole:
                self?.mainView.imageCollectionView.reloadData()
            }
        }
    }
}

// MARK: - Event

extension AddMemoViewController {
    @objc func titleTextEditingChanged(_: UITextField) {
        checkInputData()
    }

    @objc func addImageInCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(addImageAlertController, animated: true)
    }

    @objc func deleteImageButtonInCollectionViewCellPressed(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
            let cell = imageView.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = mainView.imageCollectionView.indexPath(for: cell) else { return }
        removeAndUpdateImageList(at: indexPath.row, mode: .single)
    }

    @objc func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        view.endEditing(true)
        guard let title = mainView.titleTextField.text,
            let subText = mainView.subTextView.text else { return }

        let imageList = imageViewList.filter { $0 != .addImage }

        let memoData = MemoData(title: title, subText: subText, imageList: imageList)
        presentTwoButtonAlertController(title: "메모 추가", message: "해당 메모를 추가하시겠습니까?") { [weak self] isApproval in
            if isApproval {
                DispatchQueue.main.async {
                    do {
                        try UserDataManager.shared.addMemoData(memoData)
                        self?.navigationController?.presentToastView("메모 저장에 성공했습니다.")
                    } catch {
                        self?.navigationController?.presentToastView("메모 저장에 실패했습니다.\n\(String(describing: (error as? UserDataError)?.message))")
                    }
                    self?.updateMainMemoList()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - CanSendDataDelegate

extension AddMemoViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        guard let urlImage = data as? UIImage else { return }
        insertAndUpdateImageList(at: 1, image: urlImage)
    }
}

// MARK: - UICollectionViewDataSource

extension AddMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        mainView.configureImageInfoLabel(isImageData: imageViewList.isEmpty ? false : true)
        return imageViewList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let addImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItemCell = indexPath.item == 0 ? true : false
        addImageCollectionViewCell.configureCell(image: imageViewList[indexPath.item], imageMode: MemoMode.edit, indexPath: indexPath)

        if isFirstItemCell {
            addImageCollectionViewCell.photoImageView.addGestureRecognizer(addImageTapGestureRecognizer)
        } else {
            let deleteImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteImageButtonInCollectionViewCellPressed(_:)))
            addImageCollectionViewCell.deleteImageView.addGestureRecognizer(deleteImageTapGestureRecognizer)
        }

        return addImageCollectionViewCell
    }
}

// MARK: - UINavigationControllerDelegate

extension AddMemoViewController: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension AddMemoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true) { [weak self] in
            self?.insertAndUpdateImageList(at: 1, image: selectedImage)
        }
    }
}

// MARK: - UITextViewDelegate

extension AddMemoViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        checkInputData()
    }

    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text?.trimmingCharacters(in: .whitespaces).isEmpty ?? true {
            textView.textColor = .lightGray
            textView.text = "메모 내용을 입력해주세요."
        }
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == .lightGray {
            textView.text = ""
            textView.textColor = .black
        }
    }
}
