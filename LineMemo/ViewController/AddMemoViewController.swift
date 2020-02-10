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

class AddMemoViewController: UIViewController {
    // MARK: UI

    // MARK: - IB

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var editImageBarButtonItem: UIBarButtonItem!
    @IBOutlet var addMemoBarButtonItem: UIBarButtonItem!

    private let addImageTapGestureRecognizer = UITapGestureRecognizer()
    private lazy var selectImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()

    // MARK: Properties

    private var imageViewList: [UIImage] = [#imageLiteral(resourceName: "plus")] {
        didSet {
            editImageBarButtonItem.isEnabled = imageViewList.count > 1
        }
    }

    private var isValidInputData = false {
        didSet {
            addMemoBarButtonItem.isEnabled = isValidInputData
        }
    }

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureAlertController()
        configureimagePickerController()
        configureTextField()
        configureTextView()
        configureAddMemoBarButtonItem()
        configureEditImageBarButtonItem()
        addImageTapGestureRecognizer.addTarget(self, action: #selector(addImageCollectionViewCellPressed(_:)))
    }

    private func configureEditImageBarButtonItem() {}

    private func configureAddMemoBarButtonItem() {
        addMemoBarButtonItem.isEnabled = false
    }

    private func configureimagePickerController() {
        imagePickerController.delegate = self
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

        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        selectImageAlertController.addAction(takePictureAlertAction)
        selectImageAlertController.addAction(getAlbumAlertAction)
        selectImageAlertController.addAction(cancelAlertAction)
    }

    private func presentAlbumAuthRequestAlertController() {
        DispatchQueue.main.async {
            self.presentAuthRequestAlertController(title: "앨범 접근권한 필요", message: "앨범사용을 위해 앨범 접근권한이 필요합니다.")
        }
    }

    private func presentCameraAuthRequestAlertController() {
        DispatchQueue.main.async {
            self.presentAuthRequestAlertController(title: "카메라 권한 필요", message: "사진촬영을 위해 카메라 권한을 허용해주세요.")
        }
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func configureTextView() {
        subTextView.configureBasicBorder()
        subTextView.delegate = self
    }

    private func configureTextField() {
        titleTextField.configureBasicBorder()
        titleTextField.delegate = self
    }

    private func checkInputData() {
        guard let titleText = titleTextField.text,
            let subText = subTextView.text else { return }
        isValidInputData = !titleText.trimmingCharacters(in: .whitespaces).isEmpty
            && !subText.trimmingCharacters(in: .whitespaces).isEmpty
    }

    // MARK: - Event

    @objc func addImageCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(selectImageAlertController, animated: true)
    }

    @IBAction func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let subText = subTextView.text else { return }

        let imageList = imageViewList.filter { $0 != AssetIdentifier.Image.plus }

        let memoData = MemoData(title: title, subText: subText, imageList: imageList)
        presentTwoButtonAlertController(title: "메모 추가", message: "해당 메모를 추가하시겠습니까?") { isApproval in
            if isApproval {
                DispatchQueue.main.async {
                    CommonData.shared.addMemoData(memoData)
                    debugPrint(CommonData.shared.memoDataList)
                    guard let navigationController = self.navigationController as? MainNavigationController else { return }
                    navigationController.reloadMemoList()
                    self.navigationController?.popViewController(animated: true)
                }
            }
        }
    }

    @IBAction func editImageBarButtonItemPressed(_: UIBarButtonItem) {}

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return imageViewList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let addImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.addImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItemCell = indexPath.item == 0 ? true : false
        if isFirstItemCell == true {
            addImageCollectionViewCell.imageView.addGestureRecognizer(addImageTapGestureRecognizer)
            addImageCollectionViewCell.configureCell(imageViewList[indexPath.item])
        } else {
            addImageCollectionViewCell.configureCell(imageViewList[imageViewList.count - indexPath.item])
        }

        return addImageCollectionViewCell
    }
}

extension AddMemoViewController: UICollectionViewDelegate {}

extension AddMemoViewController: UINavigationControllerDelegate {}

extension AddMemoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageViewList.append(selectedImage)
        DispatchQueue.main.async {
            picker.dismiss(animated: true, completion: nil)
            self.collectionView.reloadData()
        }
    }
}

extension AddMemoViewController: UITextViewDelegate {
    func textViewDidChange(_: UITextView) {
        checkInputData()
    }
}

extension AddMemoViewController: UITextFieldDelegate {
    func textField(_: UITextField, shouldChangeCharactersIn _: NSRange, replacementString _: String) -> Bool {
        checkInputData()
        return true
    }
}
