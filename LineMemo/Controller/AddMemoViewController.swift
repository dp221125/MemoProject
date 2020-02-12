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

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var addMemoBarButtonItem: UIBarButtonItem!

    private lazy var addImageTapGestureRecognizer = UITapGestureRecognizer()

    private lazy var selectImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()

    // MARK: Properties

    private var imageViewList: [UIImage] = [UIImage.addImage]

    private var isValidInputData = false {
        didSet {
            addMemoBarButtonItem.isEnabled = isValidInputData
        }
    }

    // MARK: Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureViewController()
    }
}

// MARK: - Configuration

extension AddMemoViewController: BaseViewController {
    func configureViewController() {
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
        addMemoBarButtonItem.isEnabled = false
    }

    private func configureimagePickerController() {
        imagePickerController.delegate = self
    }

    private func configureCollectionView() {
        let memoImageCollectionViewCell = UINib(nibName: UIIdentifier.Nib.CollectionViewCell.memoImage, bundle: nil)

        collectionView.register(memoImageCollectionViewCell, forCellWithReuseIdentifier: UIIdentifier.Nib.CollectionViewCell.memoImage)
        collectionView.dataSource = self
    }

    private func configureTextView() {
        subTextView.configureTextView(mode: .edit)
        subTextView.delegate = self
    }

    private func configureTextField() {
        titleTextField.configureTextField(mode: .edit)
        titleTextField.delegate = self
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

    private func checkInputData() {
        guard let titleText = titleTextField.text,
            let subText = subTextView.text else { return }
        isValidInputData = !titleText.trimmingCharacters(in: .whitespaces).isEmpty
            && !subText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    private func insertAndUpdateImageList(at index: Int, image: UIImage) {
        DispatchQueue.main.async {
            self.imageViewList.insert(image, at: index)
            self.collectionView.performBatchUpdates({
                self.collectionView.insertItems(at: [IndexPath(item: index, section: 0)])
            }, completion: nil)
        }
    }

    private func removeAndUpdateImageList(at index: Int, mode: UpdateMode) {
        DispatchQueue.main.async {
            self.imageViewList.remove(at: index)
            switch mode {
            case .single:
                self.collectionView.performBatchUpdates({
                    self.collectionView.deleteItems(at: [IndexPath(item: index, section: 0)])
                }, completion: nil)
            case .whole:
                self.collectionView.reloadData()
            }
        }
    }
}

// MARK: - Event

extension AddMemoViewController {
    @objc func addImageInCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(selectImageAlertController, animated: true)
    }

    @objc func deleteImageButtonInCollectionViewCellPressed(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
            let cell = imageView.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) else { return }
        removeAndUpdateImageList(at: indexPath.row, mode: .single)
    }

    @IBAction func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        view.endEditing(true)
        guard let title = titleTextField.text,
            let subText = subTextView.text else { return }

        let imageList = imageViewList.filter { $0 != .addImage }

        let memoData = MemoData(title: title, subText: subText, imageList: imageList)
        presentTwoButtonAlertController(title: "메모 추가", message: "해당 메모를 추가하시겠습니까?") { isApproval in
            if isApproval {
                DispatchQueue.main.async {
                    do {
                        try UserDataManager.shared.addMemoData(memoData)
                        self.navigationController?.presentToastView("메모 저장에 성공했습니다.")
                    } catch {
                        self.navigationController?.presentToastView("메모 저장에 실패했습니다.\n\(error)")
                    }
                    self.updateMainMemoList()
                    self.navigationController?.popViewController(animated: true)
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
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        insertAndUpdateImageList(at: 1, image: selectedImage)
        picker.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITextViewDelegate

extension AddMemoViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        checkInputData()
    }
}

// MARK: - UITextFieldDelegate

extension AddMemoViewController: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        checkInputData()
        return true
    }
}
