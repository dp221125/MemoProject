//
//  DetailMemoViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/11.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class DetailMemoViewController: UIViewController {
    // MARK: UI

    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var cancelEditBarButtonItem: UIBarButtonItem!
    @IBOutlet var saveEditBarButtonItem: UIBarButtonItem!

    private var memoData = MemoData()

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

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTitleTextField()
        configureSubTextView()
        configureBarButtonItems()
        debugPrint("now memoData : \(memoData)")
    }

    // MARK: - Configuration

    private func configureBarButtonItems() {
        saveEditBarButtonItem.title = "편집"
        cancelEditBarButtonItem.title = "취소"
        cancelEditBarButtonItem.isEnabled = false
    }

    private func configureCollectionView() {
        collectionView.register(UINib(nibName: UIIdentifier.Nib.memoImageCollectionViewCell, bundle: nil), forCellWithReuseIdentifier: UIIdentifier.Cell.Collection.memoImage)
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    func configureMemoData(_ memoData: MemoData) {
        self.memoData = memoData
    }

    private func configureTitleTextField() {
        titleTextField.text = memoData.title
        titleTextField.layer.borderWidth = 0
    }

    private func configureSubTextView() {
        subTextView.text = memoData.subText
        subTextView.setContentOffset(.zero, animated: false)
    }

    private func configureAddImageButton(imageMode: ImageMode) {
        switch imageMode {
        case .view:
            memoData.imageList = memoData.imageList.filter { $0 != AssetIdentifier.Image.plus }
        case .edit:
            memoData.imageList.insert(AssetIdentifier.Image.plus, at: 0)
        }
    }

    // MARK: - Event

    @IBAction func editBarButtonItemPressed(_: UIBarButtonItem) {
        print("Edit BarButtonItem Pressed")
        switch imageMode {
        case .view:
            imageMode = .edit
        case .edit:
            // update memoData
            guard let titleText = titleTextField.text,
                let subText = subTextView.text else { return }
            let imageList = memoData.imageList.filter { $0 != AssetIdentifier.Image.plus }
            let newMemoData = MemoData(id: memoData.id, title: titleText, subText: subText, imageList: imageList)
            memoData = newMemoData
            CommonData.shared.updateMemoData(newMemoData, at: memoData.id)
            imageMode = .view
            updateMainMemoList()
        }
    }

    @IBAction func cancelEditBarButtonItemPressed(_: UIBarButtonItem) {
        imageMode = .view
    }
}

extension DetailMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return memoData.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        let isFirstItem = indexPath.row == 0 ? true : false
        imageCollectionViewCell.configureCell(image: memoData.imageList[indexPath.item], isFirstItem: isFirstItem, imageMode: imageMode)
        return imageCollectionViewCell
    }
}

extension DetailMemoViewController: UICollectionViewDelegate {}
