//
//  AddMemoViewController.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/10.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

class AddMemoViewController: UIViewController {
    // MARK: UI

    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var titleTextField: UITextField!
    @IBOutlet var subTextView: UITextView!

    // MARK: Properties

    private var imageViewList = [UIImage]()

    // MARK: Method

    // MARK: - Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureTextField()
        configureTextView()
    }

    private func configureCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
    }

    private func configureTextView() {
        subTextView.layer.borderColor = UIColor.black.cgColor
        subTextView.layer.borderWidth = 1
    }

    private func configureTextField() {
        titleTextField.layer.borderColor = UIColor.black.cgColor
        titleTextField.layer.borderWidth = 1
    }

    // MARK: - Event

    override func touchesBegan(_: Set<UITouch>, with _: UIEvent?) {
        view.endEditing(true)
    }
}

extension AddMemoViewController: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return imageViewList.count + 1
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let addImageCollectionViewCell = collectionView.dequeueReusableCell(withReuseIdentifier: UIIdentifier.Cell.Collection.addImage, for: indexPath) as? MemoImageCollectionViewCell else { return UICollectionViewCell() }

        return addImageCollectionViewCell
    }
}

extension AddMemoViewController: UICollectionViewDelegate {}
