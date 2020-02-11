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

class DetailMemoViewController: UIViewController {
    // MARK: UI

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cancelEditBarButtonItem: UIBarButtonItem!
    @IBOutlet var saveEditBarButtonItem: UIBarButtonItem!

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

    private var imageMode = ImageMode.view {
        didSet {
            switch imageMode {
            case .view:
                cancelEditBarButtonItem.isEnabled = false
                saveEditBarButtonItem.title = "편집"
                titleTextField.isEnabled = false
                subTextView.isEditable = false
            case .edit:
                cancelEditBarButtonItem.isEnabled = true
                saveEditBarButtonItem.title = "저장"
                titleTextField.isEnabled = true
                subTextView.isEditable = true
            }

            configureAddImageButton(imageMode: imageMode)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }

    private var isInputData = true {
        didSet {
            self.saveEditBarButtonItem.isEnabled = isInputData
        }
    }

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeMemoData()
        configureCollectionView()
        configureTitleTextField()
        configureSubTextView()
        configureBarButtonItems()
        configureAlertController()
        configureAddImageTapGestureRecognizer()
        debugPrint("now memoData : \(originMemoData)")
    }

    // MARK: - Configuration

    private func configureBarButtonItems() {
        saveEditBarButtonItem.title = "편집"
        cancelEditBarButtonItem.title = "취소"
        cancelEditBarButtonItem.isEnabled = false
    }

    private func configureAddImageTapGestureRecognizer() {
        addImageTapGestureRecognizer.addTarget(self, action: #selector(addImageInCollectionViewCellPressed(_:)))
    }

    private func configureCollectionView() {
        collectionView.register(UINib(nibName: UIIdentifier.Nib.memoImageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: UIIdentifier.Cell.Collection.memoImage)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configureMemoData(_ memoData: MemoData) {
        originMemoData = memoData
    }

    private func configureTitleTextField() {
        titleTextField.addTarget(self, action: #selector(titleTextEditingChanged(_:)), for: .editingChanged)
        titleTextField.layer.borderWidth = 0
    }

    private func configureSubTextView() {
        subTextView.delegate = self
        subTextView.setContentOffset(.zero, animated: false)
    }

    private func configureAddImageButton(imageMode: ImageMode) {
        switch imageMode {
        case .view:
            editingMemoData.imageList = editingMemoData.imageList.filter { $0 != .addImage }
        case .edit:
            editingMemoData.imageList.insert(.addImage, at: 0)
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
            // URL 이미지등록 화면으로 이동
            DispatchQueue.main.async {
                self.performSegue(withIdentifier: UIIdentifier.Segue.goToAddURLImageView, sender: nil)
            }
        }

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        selectImageAlertController.addAction(takePictureAlertAction)
        selectImageAlertController.addAction(getAlbumAlertAction)
        selectImageAlertController.addAction(getPictureFromURLAction)
        selectImageAlertController.addAction(cancelAlertAction)
    }

    private func updateTempMemoData(title: String, subText: String, imageList: [UIImage]) {
        editingMemoData.title = title
        editingMemoData.subText = subText
        editingMemoData.imageList = imageList
    }

    private func initializeMemoData() {
        titleTextField.text = originMemoData.title
        subTextView.text = originMemoData.subText
        editingMemoData = originMemoData
    }

    private func checkInputData() {
        guard let titleText = titleTextField.text,
            let subText = subTextView.text else { return }
        isInputData = !titleText.trimmingCharacters(in: .whitespaces).isEmpty && !subText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Event

    @objc func titleTextEditingChanged(_: UITextField) {
        checkInputData()
    }

    @objc func addImageInCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(selectImageAlertController, animated: true)
    }

    @objc func deleteImageInCollectionViewCellPressed(_ sender: UITapGestureRecognizer) {
        guard let memoImageCollectionViewCell = sender.view?.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: memoImageCollectionViewCell) else { return }
        editingMemoData.imageList.remove(at: indexPath.item)
    }

    @IBAction func editBarButtonItemPressed(_: UIBarButtonItem) {
        print("Edit BarButtonItem Pressed")
        switch imageMode {
        case .view:
            imageMode = .edit
        case .edit:
            guard let titleText = titleTextField.text,
                let subText = subTextView.text else { return }

            updateTempMemoData(title: titleText, subText: subText, imageList: originMemoData.imageList.filter { $0 != .addImage })
            originMemoData = editingMemoData
            CommonData.shared.updateMemoData(editingMemoData, at: originMemoData.id)
            updateMainMemoList()
            imageMode = .view
        }
    }

    @IBAction func cancelEditBarButtonItemPressed(_: UIBarButtonItem) {
        initializeMemoData()
        imageMode = .view
    }
}

extension DetailMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return editingMemoData.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItem = indexPath.row == 0 ? true : false
        imageCollectionViewCell.configureCell(image: editingMemoData.imageList[indexPath.item], isFirstItem: isFirstItem, imageMode: imageMode)

        if imageMode == .edit {
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

extension DetailMemoViewController: UICollectionViewDelegate {}

extension DetailMemoViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        checkInputData()
    }
}
