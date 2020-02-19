//
//  EditMemoView.swift
//  LineMemo
//
//  Created by MinKyeongTae on 2020/02/16.
//  Copyright © 2020 MinKyeongTae. All rights reserved.
//

import UIKit

// MARK: - EditMemoView

/// * 메모편집, 메모추가 뷰
class EditMemoView: UIView {
    // MARK: UI

    private let stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.spacing = ViewSize.basicSpacing
        stackView.alignment = .center
        return stackView
    }()

    private let imageInfoLabel: UILabel = {
        let imageInfoLabel = UILabel()
        imageInfoLabel.textColor = .black
        imageInfoLabel.font = UIFont.subFont()
        imageInfoLabel.textAlignment = .center
        imageInfoLabel.adjustsFontSizeToFitWidth = true
        imageInfoLabel.text = "이미지가 존재하지 않습니다."
        imageInfoLabel.isHidden = true
        return imageInfoLabel
    }()

    private let imageLabel: UILabel = {
        let photoLabel = UILabel()
        photoLabel.textColor = .black
        photoLabel.font = UIFont.titleFont()
        photoLabel.text = "사진"
        return photoLabel
    }()

    private let titleLabel: UILabel = {
        let titleLabel = UILabel()
        titleLabel.textColor = .black
        titleLabel.text = "제목"
        titleLabel.font = UIFont.titleFont()
        return titleLabel
    }()

    private let subTextLabel: UILabel = {
        let subTextLabel = UILabel()
        subTextLabel.textColor = .black
        subTextLabel.text = "내용"
        subTextLabel.font = UIFont.titleFont()
        return subTextLabel
    }()

    let imageCollectionView: UICollectionView = {
        let imageCollectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: MemoImageCollectionViewFlowLayout())
        imageCollectionView.accessibilityIdentifier = XCTIdentifier.AddMemoView.imageCollectionView
        imageCollectionView.isScrollEnabled = true
        imageCollectionView.isUserInteractionEnabled = true
        imageCollectionView.alwaysBounceHorizontal = true
        imageCollectionView.backgroundColor = .clear
        imageCollectionView.layer.borderColor = UIColor.lightGray.cgColor
        imageCollectionView.layer.borderWidth = ViewSize.BorderWidth.basic
        let memoImageCollectionViewCell = UINib(nibName: UIIdentifier.Nib.CollectionViewCell.memoImage, bundle: nil)
        imageCollectionView.register(memoImageCollectionViewCell, forCellWithReuseIdentifier: UIIdentifier.Nib.CollectionViewCell.memoImage)
        return imageCollectionView
    }()

    let titleTextField: UITextField = {
        let titleTextField = UITextField()
        titleTextField.textColor = .black
        titleTextField.font = UIFont.mainFont()
        titleTextField.accessibilityIdentifier = XCTIdentifier.AddMemoView.titleTextField
        return titleTextField
    }()

    let subTextView: UITextView = {
        let subTextView = UITextView()
        subTextView.font = UIFont.mainFont()
        subTextView.accessibilityIdentifier = XCTIdentifier.AddMemoView.subTextView
        return subTextView
    }()

    // MARK: Initializer

    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
}

// MARK: - Configuration

extension EditMemoView: ViewSetting {
    func configureView() {
        accessibilityIdentifier = XCTIdentifier.AddMemoView.mainView
        backgroundColor = .white
        addSubviews()
        makeConstraints()
    }

    func addSubviews() {
        stackView.addArrangedSubview(imageLabel)
        stackView.addArrangedSubview(imageCollectionView)
        stackView.addArrangedSubview(titleLabel)
        stackView.addArrangedSubview(titleTextField)
        stackView.addArrangedSubview(subTextLabel)
        stackView.addArrangedSubview(subTextView)
        addSubview(stackView)
        addSubview(imageInfoLabel)
    }

    func makeConstraints() {
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.leftAnchor.constraint(equalTo: self.safeAreaLeftAnchor),
            stackView.rightAnchor.constraint(equalTo: self.safeAreaRightAnchor),
            stackView.topAnchor.constraint(equalTo: self.safeAreaTopAnchor, constant: ViewSize.basicInset),
            stackView.bottomAnchor.constraint(equalTo: self.safeAreaBottomAnchor, constant: -ViewSize.basicInset),
        ])

        imageLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageLabel.leftAnchor.constraint(equalTo: self.stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            imageLabel.rightAnchor.constraint(equalTo: self.stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            imageLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
        ])

        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            titleLabel.leftAnchor.constraint(equalTo: self.stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            titleLabel.rightAnchor.constraint(equalTo: self.stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            titleLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
        ])

        subTextLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            subTextLabel.leftAnchor.constraint(equalTo: self.stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            subTextLabel.rightAnchor.constraint(equalTo: self.stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            subTextLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
        ])

        imageCollectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            imageCollectionView.leftAnchor.constraint(equalTo: self.safeAreaLeftAnchor),
            imageCollectionView.rightAnchor.constraint(equalTo: self.safeAreaRightAnchor),
            imageCollectionView.heightAnchor.constraint(equalToConstant: ViewSize.Height.imageCollectionView),
        ])

        titleTextField.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.titleTextField.leftAnchor.constraint(equalTo: self.stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            self.titleTextField.rightAnchor.constraint(equalTo: self.stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
            self.titleTextField.heightAnchor.constraint(equalToConstant: ViewSize.Height.textField),
        ])

        subTextView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.subTextView.leftAnchor.constraint(equalTo: self.stackView.safeAreaLeftAnchor, constant: ViewSize.basicInset),
            self.subTextView.rightAnchor.constraint(equalTo: self.stackView.safeAreaRightAnchor, constant: -ViewSize.basicInset),
        ])

        imageInfoLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageInfoLabel.leftAnchor.constraint(equalTo: stackView.safeAreaLeftAnchor),
            self.imageInfoLabel.rightAnchor.constraint(equalTo: stackView.safeAreaRightAnchor),
            self.imageInfoLabel.centerYAnchor.constraint(equalTo: self.imageCollectionView.centerYAnchor),
            self.imageInfoLabel.centerXAnchor.constraint(equalTo: self.imageCollectionView.centerXAnchor),
            self.imageInfoLabel.heightAnchor.constraint(equalToConstant: ViewSize.Height.titleLabel),
        ])
    }

    func configureImageInfoLabel(isImageData: Bool) {
        if isImageData {
            imageInfoLabel.isHidden = true
        } else {
            imageInfoLabel.isHidden = false
        }
    }
}
