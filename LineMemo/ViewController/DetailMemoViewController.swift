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

    private var memoData = MemoData()
    private var imageMode = ImageMode.view

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTitleTextField()
        configureSubTextView()
    }

    // MARK: - Configuration

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
    }

    // MARK: - Event

    @IBAction func editBarButtonItemPressed(_: UIBarButtonItem) {
        print("Edit BarButtonItem Pressed")
    }
}

extension DetailMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return memoData.imageList.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let imageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.memoImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }
        imageCollectionViewCell.configureCell(image: memoData.imageList[indexPath.item], isFirstItem: true, imageMode: imageMode)
        return imageCollectionViewCell
    }
}

extension DetailMemoViewController: UICollectionViewDelegate {}
