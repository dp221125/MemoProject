//
//  DetailMemoViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import AVFoundation
import Photos
import UIKit

// MARK: - DetailMemoViewController

/// * 메모 상세보기 뷰컨트롤러
class DetailMemoViewController: UIViewController {
    // MARK: UI

    private let mainView = EditMemoView()
    private var cancelBarButtonItem = UIBarButtonItem()
    private var saveEditBarButtonItem = UIBarButtonItem()

    // MARK: Properties

    private lazy var addImageTapGestureRecognizer = UITapGestureRecognizer()

    private lazy var selectImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.delegate = self
        return imagePickerController
    }()

    private var originMemoData = MemoData()
    private var editingMemoData = MemoData()

    private var imageMode = MemoMode.view {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let imageMode = self?.imageMode else { return }
                self?.configureByMemoMode(mode: imageMode)
                self?.mainView.imageCollectionView.reloadData()
            }
        }
    }

    private var isValidInputData = true {
        didSet {
            self.saveEditBarButtonItem.isEnabled = isValidInputData
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

extension DetailMemoViewController: ViewControllerSetting {
    func configureViewController() {
        title = TitleData.detailMemoView
        initializeMemoData()
        configureCollectionView()
        configureTitleTextField()
        configureSubTextView()
        configureBarButtonItems()
        configureAlertController()
        configureAddImageTapGestureRecognizer()
    }

    func configureMemoData(_ memoData: MemoData) {
        originMemoData = memoData
    }

    private func configureBarButtonItems() {
        configureSaveEditBarButtonItem()
        configureCancelBarButtonItem()
    }

    private func configureCancelBarButtonItem() {
        cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEditBarButtonItemPressed(_:)))
        cancelBarButtonItem.tintColor = .black
        cancelBarButtonItem.isEnabled = false
    }

    private func configureSaveEditBarButtonItem() {
        saveEditBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editBarButtonItemPressed(_:)))
        saveEditBarButtonItem.tintColor = .black
        navigationItem.rightBarButtonItems = [saveEditBarButtonItem, cancelBarButtonItem]
    }

    private func configureAddImageTapGestureRecognizer() {
        addImageTapGestureRecognizer.addTarget(self, action: #selector(addImageInCollectionViewCellPressed(_:)))
    }

    private func configureCollectionView() {
        mainView.imageCollectionView.register(UINib(nibName: UIIdentifier.Nib.CollectionViewCell.memoImage, bundle: nil), forCellWithReuseIdentifier: UIIdentifier.Cell.Collection.memoImage)
        mainView.imageCollectionView.dataSource = self
    }

    private func configureTitleTextField() {
        mainView.titleTextField.addTarget(self, action: #selector(titleTextEditingChanged(_:)), for: .editingChanged)
        mainView.titleTextField.configureTextField(mode: .view)
    }

    private func configureSubTextView() {
        mainView.subTextView.delegate = self
        mainView.subTextView.configureTextView(mode: .view)
    }

    private func configureByMemoMode(mode: MemoMode) {
        mainView.titleTextField.configureTextField(mode: mode)
        mainView.subTextView.configureTextView(mode: mode)
        switch imageMode {
        case .view:
            saveEditBarButtonItem.title = "편집"
            saveEditBarButtonItem.isEnabled = true
            cancelBarButtonItem.isEnabled = false
            mainView.titleTextField.isEnabled = false
            mainView.subTextView.isEditable = false
            navigationItem.rightBarButtonItems = [saveEditBarButtonItem]
            editingMemoData.imageList = editingMemoData.imageList.filter { $0 != .addImage }
        case .edit:
            saveEditBarButtonItem.title = "저장"
            cancelBarButtonItem.isEnabled = true
            mainView.titleTextField.isEnabled = true
            mainView.subTextView.isEditable = true
            navigationItem.rightBarButtonItems = [saveEditBarButtonItem, cancelBarButtonItem]
            insertAndUpdateImageList(at: 0, image: .addImage, mode: .whole)
        }
    }

    private func insertAndUpdateImageList(at index: Int = 1, image: UIImage, mode: UpdateMode) {
        DispatchQueue.main.async { [weak self] in
            self?.editingMemoData.imageList.insert(image, at: index)
            switch mode {
            case .single:
                self?.mainView.imageCollectionView.performBatchUpdates({
                    self?.beginIgnoringInteractionEvents()
                    self?.mainView.imageCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                }) { _ in
                    self?.endIgnoringInteractionEvents()
                }
            case .whole:
                self?.mainView.imageCollectionView.reloadData()
            }
        }
    }

    private func removeAndUpdateImageList(at index: Int, mode: UpdateMode) {
        DispatchQueue.main.async { [weak self] in
            self?.editingMemoData.imageList.remove(at: index)
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

    private func configureAlertController() {
        /// 사진촬영을 선택 시 이벤트 정의
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
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

        /// 앨범사진을 선택 시 이벤트 정의
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

        let getPictureFromURLAction = UIAlertAction(title: "URL로 등록하기", style: .default) { [weak self] _ in

            DispatchQueue.main.async {
                let addImageURLViewController = AddImageURLViewController()
                addImageURLViewController.delegate = self
                self?.presentViewController(destination: addImageURLViewController)
            }
        }

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        selectImageAlertController.addAction(takePictureAlertAction)
        selectImageAlertController.addAction(getAlbumAlertAction)
        selectImageAlertController.addAction(getPictureFromURLAction)
        selectImageAlertController.addAction(cancelAlertAction)
    }

    private func updateEditingMemoData(title: String, subText: String, imageList: [UIImage]) {
        editingMemoData.title = title
        editingMemoData.subText = subText
        editingMemoData.imageList = imageList
    }

    private func initializeMemoData() {
        mainView.titleTextField.text = originMemoData.title
        mainView.subTextView.text = originMemoData.subText
        editingMemoData = originMemoData
    }

    private func checkInputData() {
        guard let titleText = mainView.titleTextField.text,
            let subText = mainView.subTextView.text else { return }
        isValidInputData = !titleText.trimmingCharacters(in: .whitespaces).isEmpty &&
            (mainView.subTextView.textColor == .black && !subText.trimmingCharacters(in: .whitespaces).isEmpty)
    }
}

// MARK: - Event

extension DetailMemoViewController {
    @objc func titleTextEditingChanged(_: UITextField) {
        checkInputData()
    }

    @objc func addImageInCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(selectImageAlertController, animated: true)
    }

    @objc func deleteImageInCollectionViewCellPressed(_ sender: UITapGestureRecognizer) {
        guard let memoImageCollectionViewCell = sender.view?.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = self.mainView.imageCollectionView.indexPath(for: memoImageCollectionViewCell) else { return }
        removeAndUpdateImageList(at: indexPath.item, mode: .single)
    }

    @objc func editBarButtonItemPressed(_: UIBarButtonItem) {
        switch imageMode {
        case .view:
            imageMode = .edit
        case .edit:
            guard let titleText = mainView.titleTextField.text,
                let subText = mainView.subTextView.text else { return }

            updateEditingMemoData(title: titleText, subText: subText, imageList: editingMemoData.imageList.filter { $0 != .addImage })
            originMemoData = editingMemoData
            do {
                try UserDataManager.shared.updateMemoData(memoData: originMemoData, at: UserDataManager.shared.editingMemoIndex)
                navigationController?.presentToastView("메모 저장에 성공했습니다.")
            } catch {
                navigationController?.presentToastView("메모 저장에 실패했습니다.\n\(String(describing: (error as? UserDataError)?.message))")
            }

//            updateMainMemoList()
            imageMode = .view
        }
    }

    @objc func cancelEditBarButtonItemPressed(_: UIBarButtonItem) {
        initializeMemoData()
        imageMode = .view
    }

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

// MARK: - CanSendDataDelegate

extension DetailMemoViewController: SendDataDelegate {
    func sendData<T>(_ data: T) {
        guard let urlImage = data as? UIImage else { return }
        insertAndUpdateImageList(at: 1, image: urlImage, mode: .single)
    }
}

// MARK: - UICollectionViewDataSource

extension DetailMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        mainView.configureImageInfoLabel(isImageData: editingMemoData.imageList.isEmpty ? false : true)
        return editingMemoData.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItem = indexPath.row == 0 ? true : false
        imageCollectionViewCell.configureCell(image: editingMemoData.imageList[indexPath.item], imageMode: imageMode, indexPath: indexPath.row)

        switch imageMode {
        case .view:
            imageCollectionViewCell.removeGestureRecognizer(addImageTapGestureRecognizer)
        case .edit:
            if isFirstItem {
                imageCollectionViewCell.addGestureRecognizer(addImageTapGestureRecognizer)
            } else {
                let deleteImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteImageInCollectionViewCellPressed(_:)))
                imageCollectionViewCell.deleteImageView.addGestureRecognizer(deleteImageTapGestureRecognizer)
            }
        }

        return imageCollectionViewCell
    }
}

// MARK: - UITextViewDelegate

extension DetailMemoViewController: UITextViewDelegate {
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

// MARK: - UINavigationControllerDelegate

extension DetailMemoViewController: UINavigationControllerDelegate {}

// MARK: - UIImagePickerControllerDelegate

extension DetailMemoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        dismiss(animated: true) { [weak self] in
            self?.insertAndUpdateImageList(at: 1, image: selectedImage, mode: .single)
        }
    }

    func imagePickerControllerDidCancel(_: UIImagePickerController) {
        dismiss(animated: true)
    }
}
