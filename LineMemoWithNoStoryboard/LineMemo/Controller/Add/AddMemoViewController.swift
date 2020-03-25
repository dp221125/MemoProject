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
import RxSwift

// MARK: - AddMemoViewController
/// * 메모 추가 뷰컨트롤러
class AddMemoViewController: UIViewController {
    // MARK: UI

    private var mainView: EditMemoView {
        guard let mainView = self.view as? EditMemoView else {
            fatalError()
        }
        return mainView
    }

    private let viewModel: AddMemoViewModelType
    private let imagePicker: ImagePicker
    private let disposeBag = DisposeBag()

    // MARK: Properties
    private var imageViewList: [UIImage] = [.addImage]

    init(viewModel: AddMemoViewModelType = AddMemoViewModel()) {
        self.viewModel = viewModel
        self.imagePicker = ImagePicker(viewModel: viewModel)
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // MARK: Life Cycle

    override func loadView() {
        let view = EditMemoView()
        self.view = view
        view.subTextView.configureTextView(mode: .edit)
        view.titleTextField.configureTextField(mode: .edit)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.title = TitleData.addMemoview
        bind()
        configureAddMemoBarButtonItem()
    }
    
    func bind() {
        
        let testFieldObservable = self.mainView.titleTextField.rx.text.orEmpty.asObservable()
        let textViewObservable =
            self.mainView.subTextView.rx.text.orEmpty
                .filter { _ in self.mainView.subTextView.textColor != .lightGray }
                .asObservable()
           
        Observable.combineLatest(testFieldObservable, textViewObservable)
            .bind(onNext: self.viewModel.inputs.checkInput)
            .disposed(by: self.disposeBag)
        
        self.viewModel.outpusts.isVaild
            .subscribe(onNext: { bool in
                if self.navigationItem.rightBarButtonItem != nil {
                    self.navigationItem.rightBarButtonItem?.isEnabled = bool
                }
            })
            .disposed(by: self.disposeBag)
        
        self.mainView.subTextView.rx.didBeginEditing
            .filter({ _ in self.mainView.subTextView.textColor == .lightGray })
            .subscribe(onNext: { _ in
                 self.mainView.subTextView.text = ""
                 self.mainView.subTextView.textColor = .black
            })
            .disposed(by: self.disposeBag)
        
        self.mainView.subTextView.rx.didEndEditing
            .filter{ _ in self.mainView.subTextView.text.trimmingCharacters(in: .whitespaces).isEmpty}
            .subscribe(onNext: { _ in
                self.mainView.subTextView.textColor = .lightGray
                self.mainView.subTextView.text = "메모 내용을 입력해주세요."
            })
            .disposed(by: self.disposeBag)
        
        self.viewModel.outpusts.imageList
            .bind(to: self.mainView.imageCollectionView.rx.items(cellIdentifier: UIIdentifier.Cell.Collection.memoImage, cellType: MemoImageCollectionViewCell.self)) {
                index, item, cell in
                
                cell.configureCell(image: item, imageMode: MemoMode.edit, indexPath: index)

                if index == 0 {
                    let addImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.addImageInCollectionViewCellPressed(_:)))
                    cell.photoImageView.addGestureRecognizer(addImageTapGestureRecognizer)
                } else {
                    let deleteImageTapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.deleteImageButtonInCollectionViewCellPressed(_:)))
                    cell.deleteImageView.addGestureRecognizer(deleteImageTapGestureRecognizer)
                }
        }.disposed(by: self.disposeBag)
        
        
    }
}

// MARK: - Configuration

extension AddMemoViewController: ViewControllerSetting {
    
    private func configureAddMemoBarButtonItem() {
        let addMemoBarButtonItem = UIBarButtonItem(title: "저장", style: .plain, target: self, action: #selector(addMemoBarButtonItemPressed(_:)))
        addMemoBarButtonItem.isEnabled = false
        navigationItem.rightBarButtonItem = addMemoBarButtonItem
    }
    
    private func showImageAlertController() {
        let addImageAlertController = UIAlertController(title: "사진 등록방법 선택", message: "사진 등록방법을 선택하세요.", preferredStyle: .actionSheet)
        
        let getCameraAlertAction = UIAlertAction(title: "사진 찍기", style: .default) { [weak self] _ in
            guard let self = self else { return }
                self.imagePicker.checkCameraAuth { result in
                    switch result {
                    case .authorized:
                        self.imagePicker.setController(.camera)
                                    DispatchQueue.main.async {
                        self.present(self.imagePicker.controller, animated: true)
                        }
                    case .denial:
                        self.presentCameraAuthRequestAlertController()
                    }
                
            }
        }
        
        /// * 앨범사진 선택 시 이벤트 정의
        let getAlbumAlertAction = UIAlertAction(title: "앨범 사진 가져오기", style: .default, handler: { [weak self] _ in
            guard let self = self else { return }
            self.imagePicker.checkAlbumAuth { result in
                switch result {
                case .authorized:
                    self.imagePicker.setController(.photoLibrary)
                    DispatchQueue.main.async {
                        self.present(self.imagePicker.controller, animated: true)
                    }
                    
                case .denial:
                    self.presentCameraAuthRequestAlertController()
                }
            }
        })
        
        let getPictureFromURLAction = UIAlertAction(title: "URL로 등록하기", style: .default) { _ in
            DispatchQueue.main.async { [weak self] in
                let addImageURLViewController = AddImageURLViewController()
                addImageURLViewController.delegate = self
                self?.presentViewController(destination: addImageURLViewController)
            }
        }
        
        let cancelAlertAction = UIAlertAction(title: "취소", style: .cancel, handler: nil)
        addImageAlertController.addAction(getCameraAlertAction)
        addImageAlertController.addAction(getAlbumAlertAction)
        addImageAlertController.addAction(getPictureFromURLAction)
        addImageAlertController.addAction(cancelAlertAction)
        
        self.present(addImageAlertController, animated: true)
    }
}

// MARK: - Event

extension AddMemoViewController {

    @objc
    func addImageInCollectionViewCellPressed(_: UITapGestureRecognizer) {
        self.showImageAlertController()
    }

    @objc
    func deleteImageButtonInCollectionViewCellPressed(_ sender: UITapGestureRecognizer) {
        guard let imageView = sender.view as? UIImageView,
            let cell = imageView.superview?.superview as? MemoImageCollectionViewCell,
            let indexPath = mainView.imageCollectionView.indexPath(for: cell) else { return }
        self.viewModel.inputs.deleteButton(indexPath.row)
    }

    @objc
    func addMemoBarButtonItemPressed(_: UIBarButtonItem) {
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
        guard let urlImage = data as? UIImage, let data = urlImage.pngData() else { return }
        self.viewModel.pickerInputs.data.onNext(data)
    }
}
