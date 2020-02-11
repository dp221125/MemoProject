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

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var addMemoBarButtonItem: UIBarButtonItem!

    private let addImageTapGestureRecognizer = UITapGestureRecognizer()

    private lazy var selectImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)

    private lazy var imagePickerController: UIImagePickerController = {
        let imagePickerController = UIImagePickerController()
        imagePickerController.allowsEditing = true
        return imagePickerController
    }()

    // MARK: Properties

    private var imageViewList: [UIImage] = [#imageLiteral(resourceName: "plus")]

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

    // MARK: - Configuration

    func addImage(_ image: UIImage) {
        DispatchQueue.main.async {
            self.imageViewList.insert(image, at: 1)
            self.collectionView.reloadData()
        }
    }

    private func configureEditImageBarButtonItem() {}

    private func configureAddMemoBarButtonItem() {
        addMemoBarButtonItem.isEnabled = false
    }

    private func configureimagePickerController() {
        imagePickerController.delegate = self
    }

    private func configureCollectionView() {
        let memoImageCollectionViewCell = UINib(nibName: UIIdentifier.Nib.memoImageCollectionViewCell, bundle: nil)

        collectionView.register(memoImageCollectionViewCell, forCellWithReuseIdentifier: UIIdentifier.Nib.memoImageCollectionViewCell)

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

    // MARK: Transition

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

    @IBAction func unwindToAddMemoView(_: UIStoryboardSegue) {}

    // MARK: - Event

    @objc func addImageCollectionViewCellPressed(_: UITapGestureRecognizer) {
        present(selectImageAlertController, animated: true)
    }

    @objc func deleteImageButtonPressed(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
            let cell = imageView.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = self.collectionView.indexPath(for: cell) else { return }
        print(indexPath)

        collectionView.performBatchUpdates({
            imageViewList.remove(at: indexPath.row)
            collectionView.deleteItems(at: [indexPath])
        }, completion: nil)
    }

    @IBAction func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
        guard let title = titleTextField.text,
            let subText = subTextView.text else { return }

        let imageList = imageViewList.filter { $0 != .addImage }

        let memoData = MemoData(id: CommonData.shared.memoDataList.count, title: title, subText: subText, imageList: imageList)
        presentTwoButtonAlertController(title: "메모 추가", message: "해당 메모를 추가하시겠습니까?") { isApproval in
            if isApproval {
                DispatchQueue.main.async {
                    CommonData.shared.addMemoData(memoData)
                    debugPrint(CommonData.shared.memoDataList)
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

extension AddMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return imageViewList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let addImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItemCell = indexPath.item == 0 ? true : false
        addImageCollectionViewCell.configureCell(image: imageViewList[indexPath.item], isFirstItem: isFirstItemCell, imageMode: ImageMode.edit)

        if isFirstItemCell {
            addImageCollectionViewCell.photoImageView.addGestureRecognizer(addImageTapGestureRecognizer)
        } else {
            let deleteImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(deleteImageButtonPressed(_:)))
            addImageCollectionViewCell.deleteImageView.addGestureRecognizer(deleteImageTapGestureRecognizer)
        }

        return addImageCollectionViewCell
    }
}

extension AddMemoViewController: UICollectionViewDelegate {}

extension AddMemoViewController: UINavigationControllerDelegate {}

extension AddMemoViewController: UIImagePickerControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        guard let selectedImage = info[.editedImage] as? UIImage else { return }
        imageViewList.insert(selectedImage, at: 1)
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
