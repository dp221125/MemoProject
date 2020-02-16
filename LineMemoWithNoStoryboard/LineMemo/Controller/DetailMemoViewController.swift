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
        return imagePickerController
    }()

    private var originMemoData = MemoData()
    private var editingMemoData = MemoData()

    private var imageMode = MemoMode.view {
        didSet {
            configureByMemoMode(mode: imageMode)
            DispatchQueue.main.async {
                self.mainView.imageCollectionView.reloadData()
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
        self.view = mainView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension DetailMemoViewController: ViewControllerSetting {
    func configureViewController() {
        initializeMemoData()
        configureCollectionView()
        configureTitleTextField()
        configureSubTextView()
        configureBarButtonItems()
        configureAlertController()
        configureAddImageTapGestureRecognizer()
        configureImagePickerController()
    }

    func configureMemoData(_ memoData: MemoData) {
        originMemoData = memoData
    }

    private func configureImagePickerController() {
        imagePickerController.delegate = self
    }

    private func configureBarButtonItems() {
        cancelBarButtonItem.isEnabled = false
        cancelBarButtonItem = UIBarButtonItem(title: "취소", style: .plain, target: self, action: #selector(cancelEditBarButtonItemPressed(_:)))
        cancelBarButtonItem.tintColor = .black
        
        saveEditBarButtonItem = UIBarButtonItem(title: "편집", style: .plain, target: self, action: #selector(editBarButtonItemPressed(_:)))
        saveEditBarButtonItem.tintColor = .black
        self.navigationItem.rightBarButtonItems = [saveEditBarButtonItem, cancelBarButtonItem]
    }

    private func configureAddImageTapGestureRecognizer() {
        addImageTapGestureRecognizer.addTarget(self, action: #selector(addImageInCollectionViewCellPressed(_:)))
    }

    private func configureCollectionView() {
        self.mainView.imageCollectionView.register(UINib(nibName: UIIdentifier.Nib.CollectionViewCell.memoImage, bundle: nil), forCellWithReuseIdentifier: UIIdentifier.Cell.Collection.memoImage)
        self.mainView.imageCollectionView.dataSource = self
    }

    private func configureTitleTextField() {
        self.mainView.titleTextField.addTarget(self, action: #selector(titleTextEditingChanged(_:)), for: .editingChanged)
        self.mainView.titleTextField.configureTextField(mode: .view)
    }

    private func configureSubTextView() {
        self.mainView.subTextView.delegate = self
        self.mainView.subTextView.configureTextView(mode: .view)
    }

    private func configureByMemoMode(mode: MemoMode) {
        self.mainView.titleTextField.configureTextField(mode: mode)
        self.mainView.subTextView.configureTextView(mode: mode)
        switch imageMode {
        case .view:
            cancelBarButtonItem.isEnabled = false
            saveEditBarButtonItem.isEnabled = true
            self.mainView.titleTextField.isEnabled = false
            self.mainView.subTextView.isEditable = false
            saveEditBarButtonItem.title = "편집"
            editingMemoData.imageList = editingMemoData.imageList.filter { $0 != .addImage }
        case .edit:
            cancelBarButtonItem.isEnabled = true
            self.mainView.titleTextField.isEnabled = true
            self.mainView.subTextView.isEditable = true
            saveEditBarButtonItem.title = "저장"
            insertAndUpdateImageList(at: 0, image: .addImage, mode: .whole)
        }
    }

    private func insertAndUpdateImageList(at index: Int, image: UIImage, mode: UpdateMode) {
        DispatchQueue.main.async {
            self.editingMemoData.imageList.insert(image, at: index)
            switch mode {
            case .single:
                self.mainView.imageCollectionView.performBatchUpdates({
                    self.mainView.imageCollectionView.insertItems(at: [IndexPath(item: index, section: 0)])
                }, completion: nil)
            case .whole:
                self.mainView.imageCollectionView.reloadData()
            }
        }
    }

    private func removeAndUpdateImageList(at index: Int, mode: UpdateMode) {
        DispatchQueue.main.async {
            self.editingMemoData.imageList.remove(at: index)
            switch mode {
            case .single:
                self.mainView.imageCollectionView.performBatchUpdates({
                    self.mainView.imageCollectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }, completion: nil)
            case .whole:
                self.mainView.imageCollectionView.reloadData()
            }
        }
    }

    private func configureAlertController() {
        /// 사진촬영을 선택 시 이벤트 정의
        let takePictureAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { _ in
            let cameraType = AVMediaType.video
            let cameraStatus = AVCaptureDevice.authorizationStatus(for: cameraType)
            switch cameraStatus {
            case .authorized:
                self.openCamera(self.imagePickerController)
            case .notDetermined:
                AVCaptureDevice.requestAccess(for: cameraType, completionHandler: { granted in
                    if granted {
                        self.openCamera(self.imagePickerController)
                    }
                })
            default:
                self.presentCameraAuthRequestAlertController()
            }
        }

        /// 앨범사진을 선택 시 이벤트 정의
        let getAlbumAlertAction = UIAlertAction(title: "앨범 사진 가져오기", style: .default, handler: { _ in
            let albumAuthorizationStatus = PHPhotoLibrary.authorizationStatus()

            DispatchQueue.main.async {
                switch albumAuthorizationStatus {
                case .authorized:
                    self.openAlbum(self.imagePickerController)
                case .notDetermined:
                    PHPhotoLibrary.requestAuthorization { status in
                        switch status {
                        case .authorized:
                            self.openAlbum(self.imagePickerController)
                        default: break
                        }
                    }
                default:
                    self.presentAlbumAuthRequestAlertController()
                }
            }
        })

        let getPictureFromURLAction = UIAlertAction(title: "URL로 등록하기", style: .default) { _ in

            DispatchQueue.main.async { [weak self] in
                let mainStoryboard = UIStoryboard(name: UIIdentifier.Storyboard.main, bundle: nil)
                guard let addURLImageNavigationController = mainStoryboard.instantiateViewController(withIdentifier: UIIdentifier.Storyboard.addURLImageNavigationController) as? UINavigationController else { return }
                guard let addURLImageViewController = addURLImageNavigationController.viewControllers[0] as? AddURLImageViewController else { return }
                addURLImageViewController.delegate = self
                self?.present(addURLImageNavigationController, animated: true)
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

            updateMainMemoList()
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
        return editingMemoData.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItem = indexPath.row == 0 ? true : false
        imageCollectionViewCell.configureCell(image: editingMemoData.imageList[indexPath.item], imageMode: imageMode, indexPath: indexPath)

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
        insertAndUpdateImageList(at: 1, image: selectedImage, mode: .single)
        dismiss(animated: true, completion: nil)
    }
}
